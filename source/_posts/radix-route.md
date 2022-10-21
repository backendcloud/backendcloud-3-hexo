---
title: http基数树路由算法和Go源码分析
readmore: false
date: 2022-10-20 18:36:54
categories: 云原生
tags:
- Radix树
---


# Radix树简介

Radix Tree名为压缩前缀树，又名为基数树。听名字，就知道该算法是之前介绍的前缀树的压缩版，也就是具有共同前缀的节点拥有相同的父节点。和前缀树Trie Tree极为相似，一个最大的区别点在于它不是按照每个字符长度做节点拆分，而是可以以1个或多个字符叠加作为一个分支。这就避免了长字符key会分出深度很深的节点。Radix Tree的结构构造如下图所示：

> Trie Tree 参考{% post_link trie-route %}

![](/images/radix-route/2022-10-20-13-39-09.png)

针对Radix Tree的构造规则，它的节点插入和删除行为相比较于Trie Tree来说，略有不同：
* 对于节点插入而言，当有新的key进来，需要拆分原有公共前缀分支。
* 对于节点删除而言，当删除一个现有key后，发现其父节点只有另外一个子节点key，则此子节点可以和父节点合并为一个新的节点，以此减少树的比较深度。

![](/images/radix-route/2022-10-20-13-40-06.png)


# web框架中的快速路由 基数树

```bash
Priority   Path             Handle
9          \                *<1>
3          ├s               nil
2          |├earch\         *<2>
1          |└upport\        *<3>
2          ├blog\           *<4>
1          |    └:post      nil
1          |         └\     *<5>
2          ├about-us\       *<6>
1          |        └team\  *<7>
1          └contact\        *<8>

// 这个图相当于注册了下面这几个路由
GET("/search/", func1)
GET("/support/", func2)
GET("/blog/:post/", func3)
GET("/about-us/", func4)
GET("/about-us/team/", func5)
GET("/contact/", func6)
```

通过上面的示例可以看出：
* *<数字> 代表一个 handler 函数的内存地址（指针）
* search 和 support 拥有共同的父节点 s ，并且 s 是没有对应的 handle 的， 只有叶子节点（就是最后一个节点，下面没有子节点的节点）才会注册 handler 。
* 从根开始，一直到叶子节点，才是路由的实际路径。
* 路由搜索的顺序是从上向下，从左到右的顺序，为了快速找到尽可能多的路由，包含子节点越多的节点，优先级越高。


# golang实现

> 本次分析的源码放在 https://github.com/julienschmidt/httprouter


route,node结构体：

```go
type Router struct {
    trees map[string]*node
    ...
}
```

因为github.com/julienschmidt/httprouter是生产可用的路由模块，加入了很多细节的考虑，比如：
* 是否处理当访问路径最后带的 /
* 是否自动修正路径， 如果路由没有找到时，Router 会自动尝试修复
* 自定义 OPTIONS 路由
* 自定义http NotFound handler函数
* 自定义错误恢复handler函数
* 定义静态文件目录
* 等等

本篇主要分析路由基数树算法相关的代码，非相关的其他代码略过。

路由算法主要包括路由注册和路由发现两个部分：

## 路由注册

基数树算法相较于前缀树算法之所以快，主要在于：
* 进一步压缩前缀树，即：同前缀的节点拥有相同的父节点
* 对子节点建立了索引并按优先级从左到右排列，并将该信息保存在node结构体的indices字符数组里

下面的incrementChildPrio方法做了下面几件事：
1. 根据入参的下标，修改对应下标的子节点的优先级
2. 调整子节点数组的顺序，具体将+1优先级的子节点的优先级依次和前一个子节点的优先级做比较，若高，则互换位置
3. 重新索引。若重新排列过子节点，即 newPos != pos，即按调整后的子节点顺序重新建立索引。索引就是个字符数组，各取子节点的首字符
4. 返回最新索引的调整后的位置

> 通过建立按优先级排序的索引，可以极大缩短路由查找时间，实现快速路由。该索引不仅用在路由发现，路由注册也用到了，大大加快速度。

```go
// Increments priority of the given child and reorders if necessary
func (n *node) incrementChildPrio(pos int) int {
	cs := n.children
	cs[pos].priority++
	prio := cs[pos].priority

	// Adjust position (move to front)
	newPos := pos
	for ; newPos > 0 && cs[newPos-1].priority < prio; newPos-- {
		// Swap node positions
		cs[newPos-1], cs[newPos] = cs[newPos], cs[newPos-1]
	}

	// Build new index char string
	if newPos != pos {
		n.indices = n.indices[:newPos] + // Unchanged prefix, might be empty
			n.indices[pos:pos+1] + // The index char we move
			n.indices[newPos:pos] + n.indices[pos+1:] // Rest without char at 'pos'
	}

	return newPos
}
```

整个addRoute和insertChild方法的代码是相当绕的，但好在大多数代码在处理通配符冒号和星号，以及检测通配符冲突和不合法上面，跳过这些代码，就简单很多。（下面分析的就跳过这些内容）

addRoute方法处理下面几种情况：
1. 若是该节点是下面是空的，就是空树的情况，即当前的path和索引都为空，insertChild，并设置为root类型的节点。
2. 若入参的path和该节点有开头有重复的字段，并重复字段没有包括当前整个节点，则对该节点进行裂变，裂变成两节点。共通的节点和原节点剩下的部分作为子节点。
3. 若入参的path和该节点有开头有重复的字段，并重复字段包括当前整个节点，则对重复字段之后的字段进行处理（这部分内容分为下面2种情况）。

情况1. 若首字母可以在索引列表中找到，则增加该索引对应的子节点的优先级，并重新回到for循环开头对该子节点进行递归处理（该子节点变为当前节点），直至整个完整URL都被解析完成，并完成所有节点的更新。

情况2. 若首字母可以在索引列表中未找到，则新建子节点，加入新索引，新索引优先级+1，对新的子节点调用insertChild方法。

> 这个标识符walk名字一目了然，walk整个URL，walk整个tree。


insertChild方法就干了一件事：入参的path和handler函数赋值给node结构体。

> 由于基数树的特点，上面addRoute方法的整个过程有两处会调用insertChild方法，该方法会将未解析的整段的URL作为子节点插入当前树上。一处是空树的情况，一处是索引列表找不到的情况。换个说法就是，当前树没有任何节点时，第一个注册路由不管多长，都只增加一个节点，这和前缀树算法有明显区别，当索引找不到时，不管未解析的路由有多长，也只插入一个子节点。从这里可以看出之所以称为快速路由的原因。

```go
// addRoute adds a node with the given handle to the path.
// Not concurrency-safe!
func (n *node) addRoute(path string, handle Handle) {
	fullPath := path
	n.priority++

	// Empty tree
	if n.path == "" && n.indices == "" {
		n.insertChild(path, fullPath, handle)
		n.nType = root
		return
	}

walk:
	for {
		// Find the longest common prefix.
		// This also implies that the common prefix contains no ':' or '*'
		// since the existing key can't contain those chars.
		i := longestCommonPrefix(path, n.path)

		// Split edge
		if i < len(n.path) {
			child := node{
				path:      n.path[i:],
				wildChild: n.wildChild,
				nType:     static,
				indices:   n.indices,
				children:  n.children,
				handle:    n.handle,
				priority:  n.priority - 1,
			}

			n.children = []*node{&child}
			// []byte for proper unicode char conversion, see #65
			n.indices = string([]byte{n.path[i]})
			n.path = path[:i]
			n.handle = nil
			n.wildChild = false
		}

		// Make new node a child of this node
		if i < len(path) {
			path = path[i:]

			if n.wildChild {
				n = n.children[0]
				n.priority++

				// Check if the wildcard matches
				if len(path) >= len(n.path) && n.path == path[:len(n.path)] &&
					// Adding a child to a catchAll is not possible
					n.nType != catchAll &&
					// Check for longer wildcard, e.g. :name and :names
					(len(n.path) >= len(path) || path[len(n.path)] == '/') {
					continue walk
				} else {
					// Wildcard conflict
					pathSeg := path
					if n.nType != catchAll {
						pathSeg = strings.SplitN(pathSeg, "/", 2)[0]
					}
					prefix := fullPath[:strings.Index(fullPath, pathSeg)] + n.path
					panic("'" + pathSeg +
						"' in new path '" + fullPath +
						"' conflicts with existing wildcard '" + n.path +
						"' in existing prefix '" + prefix +
						"'")
				}
			}

			idxc := path[0]

			// '/' after param
			if n.nType == param && idxc == '/' && len(n.children) == 1 {
				n = n.children[0]
				n.priority++
				continue walk
			}

			// Check if a child with the next path byte exists
			for i, c := range []byte(n.indices) {
				if c == idxc {
					i = n.incrementChildPrio(i)
					n = n.children[i]
					continue walk
				}
			}

			// Otherwise insert it
			if idxc != ':' && idxc != '*' {
				// []byte for proper unicode char conversion, see #65
				n.indices += string([]byte{idxc})
				child := &node{}
				n.children = append(n.children, child)
				n.incrementChildPrio(len(n.indices) - 1)
				n = child
			}
			n.insertChild(path, fullPath, handle)
			return
		}

		// Otherwise add handle to current node
		if n.handle != nil {
			panic("a handle is already registered for path '" + fullPath + "'")
		}
		n.handle = handle
		return
	}
}
```

```go
func (n *node) insertChild(path, fullPath string, handle Handle) {
	for {
		// Find prefix until first wildcard
		wildcard, i, valid := findWildcard(path)
		if i < 0 { // No wilcard found
			break
		}

		// The wildcard name must not contain ':' and '*'
		if !valid {
			panic("only one wildcard per path segment is allowed, has: '" +
				wildcard + "' in path '" + fullPath + "'")
		}

		// Check if the wildcard has a name
		if len(wildcard) < 2 {
			panic("wildcards must be named with a non-empty name in path '" + fullPath + "'")
		}

		// Check if this node has existing children which would be
		// unreachable if we insert the wildcard here
		if len(n.children) > 0 {
			panic("wildcard segment '" + wildcard +
				"' conflicts with existing children in path '" + fullPath + "'")
		}

		// param
		if wildcard[0] == ':' {
			if i > 0 {
				// Insert prefix before the current wildcard
				n.path = path[:i]
				path = path[i:]
			}

			n.wildChild = true
			child := &node{
				nType: param,
				path:  wildcard,
			}
			n.children = []*node{child}
			n = child
			n.priority++

			// If the path doesn't end with the wildcard, then there
			// will be another non-wildcard subpath starting with '/'
			if len(wildcard) < len(path) {
				path = path[len(wildcard):]
				child := &node{
					priority: 1,
				}
				n.children = []*node{child}
				n = child
				continue
			}

			// Otherwise we're done. Insert the handle in the new leaf
			n.handle = handle
			return
		}

		// catchAll
		if i+len(wildcard) != len(path) {
			panic("catch-all routes are only allowed at the end of the path in path '" + fullPath + "'")
		}

		if len(n.path) > 0 && n.path[len(n.path)-1] == '/' {
			panic("catch-all conflicts with existing handle for the path segment root in path '" + fullPath + "'")
		}

		// Currently fixed width 1 for '/'
		i--
		if path[i] != '/' {
			panic("no / before catch-all in path '" + fullPath + "'")
		}

		n.path = path[:i]

		// First node: catchAll node with empty path
		child := &node{
			wildChild: true,
			nType:     catchAll,
		}
		n.children = []*node{child}
		n.indices = string('/')
		n = child
		n.priority++

		// Second node: node holding the variable
		child = &node{
			path:     path[i:],
			nType:    catchAll,
			handle:   handle,
			priority: 1,
		}
		n.children = []*node{child}

		return
	}

	// If no wildcard was found, simply insert the path and handle
	n.path = path
	n.handle = handle
}
```

## 路由发现

路由发现和路由注册的过程是类似的并且相对简单，搞懂了路由注册自然就搞懂了路由发现，这里略过。

```go
// Returns the handle registered with the given path (key). The values of
// wildcards are saved to a map.
// If no handle can be found, a TSR (trailing slash redirect) recommendation is
// made if a handle exists with an extra (without the) trailing slash for the
// given path.
func (n *node) getValue(path string, params func() *Params) (handle Handle, ps *Params, tsr bool) {
walk: // Outer loop for walking the tree
	for {
		prefix := n.path
		if len(path) > len(prefix) {
			if path[:len(prefix)] == prefix {
				path = path[len(prefix):]

				// If this node does not have a wildcard (param or catchAll)
				// child, we can just look up the next child node and continue
				// to walk down the tree
				if !n.wildChild {
					idxc := path[0]
					for i, c := range []byte(n.indices) {
						if c == idxc {
							n = n.children[i]
							continue walk
						}
					}

					// Nothing found.
					// We can recommend to redirect to the same URL without a
					// trailing slash if a leaf exists for that path.
					tsr = (path == "/" && n.handle != nil)
					return
				}

				// Handle wildcard child
				n = n.children[0]
				switch n.nType {
				case param:
					// Find param end (either '/' or path end)
					end := 0
					for end < len(path) && path[end] != '/' {
						end++
					}

					// Save param value
					if params != nil {
						if ps == nil {
							ps = params()
						}
						// Expand slice within preallocated capacity
						i := len(*ps)
						*ps = (*ps)[:i+1]
						(*ps)[i] = Param{
							Key:   n.path[1:],
							Value: path[:end],
						}
					}

					// We need to go deeper!
					if end < len(path) {
						if len(n.children) > 0 {
							path = path[end:]
							n = n.children[0]
							continue walk
						}

						// ... but we can't
						tsr = (len(path) == end+1)
						return
					}

					if handle = n.handle; handle != nil {
						return
					} else if len(n.children) == 1 {
						// No handle found. Check if a handle for this path + a
						// trailing slash exists for TSR recommendation
						n = n.children[0]
						tsr = (n.path == "/" && n.handle != nil) || (n.path == "" && n.indices == "/")
					}

					return

				case catchAll:
					// Save param value
					if params != nil {
						if ps == nil {
							ps = params()
						}
						// Expand slice within preallocated capacity
						i := len(*ps)
						*ps = (*ps)[:i+1]
						(*ps)[i] = Param{
							Key:   n.path[2:],
							Value: path,
						}
					}

					handle = n.handle
					return

				default:
					panic("invalid node type")
				}
			}
		} else if path == prefix {
			// We should have reached the node containing the handle.
			// Check if this node has a handle registered.
			if handle = n.handle; handle != nil {
				return
			}

			// If there is no handle for this route, but this route has a
			// wildcard child, there must be a handle for this path with an
			// additional trailing slash
			if path == "/" && n.wildChild && n.nType != root {
				tsr = true
				return
			}

			if path == "/" && n.nType == static {
				tsr = true
				return
			}

			// No handle found. Check if a handle for this path + a
			// trailing slash exists for trailing slash recommendation
			for i, c := range []byte(n.indices) {
				if c == '/' {
					n = n.children[i]
					tsr = (len(n.path) == 1 && n.handle != nil) ||
						(n.nType == catchAll && n.children[0].handle != nil)
					return
				}
			}
			return
		}

		// Nothing found. We can recommend to redirect to the same URL with an
		// extra trailing slash if a leaf exists for that path
		tsr = (path == "/") ||
			(len(prefix) == len(path)+1 && prefix[len(path)] == '/' &&
				path == prefix[:len(prefix)-1] && n.handle != nil)
		return
	}
}
```

## 基础方法

* min 返回较小的值
* longestCommonPrefix 返回两个字符串最长相同字符的下标的下一个下标
* findWildcard 返回是否匹配到的通配符，返回的内容通配符例如：“:land”，“*land/”，起始下标，是否合法
* countParams 返回通配符个数

```go
func min(a, b int) int {
	if a <= b {
		return a
	}
	return b
}

func longestCommonPrefix(a, b string) int {
	i := 0
	max := min(len(a), len(b))
	for i < max && a[i] == b[i] {
		i++
	}
	return i
}

// Search for a wildcard segment and check the name for invalid characters.
// Returns -1 as index, if no wildcard was found.
func findWildcard(path string) (wilcard string, i int, valid bool) {
	// Find start
	for start, c := range []byte(path) {
		// A wildcard starts with ':' (param) or '*' (catch-all)
		if c != ':' && c != '*' {
			continue
		}

		// Find end and check for invalid characters
		valid = true
		for end, c := range []byte(path[start+1:]) {
			switch c {
			case '/':
				return path[start : start+1+end], start, valid
			case ':', '*':
				valid = false
			}
		}
		return path[start:], start, valid
	}
	return "", -1, false
}

func countParams(path string) uint16 {
	var n uint
	for i := range []byte(path) {
		switch path[i] {
		case ':', '*':
			n++
		}
	}
	return uint16(n)
}
```