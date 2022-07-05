---
title: 一步步学写Bazel lib&rules （1） - Bazel官方基础库简单浏览
readmore: true
date: 2022-07-04 18:51:43
categories: Devops
tags:
- Bazel
---

Bazel很强大，但是很多人都说Bazel的学习曲线比较陡。一般的技能先要入门，然后慢慢深入，入门容易，深入难。Bazel不仅如此，往往找了半天，门都还没找到。

学习Bazel的官方基础库Skylib是一个很好的Bazel入门点，大量Bazel lib&rules会引用Skylib，避不开。学习Skylib也是复杂的lib&rules的hello-world。

> Skylib的注释非常详细，比文章里描述的强太多了，可以看完几个下面的几个例子，然后直接看源码。

# lib

## collections.bzl

```python
"""Skylib module containing functions that operate on collections."""

def _after_each(separator, iterable):
    """Inserts `separator` after each item in `iterable`.
    Args:
      separator: The value to insert after each item in `iterable`.
      iterable: The list into which to intersperse the separator.
    Returns:
      A new list with `separator` after each item in `iterable`.
    """
    result = []
    for x in iterable:
        result.append(x)
        result.append(separator)

    return result

def _before_each(separator, iterable):
    """Inserts `separator` before each item in `iterable`.
    Args:
      separator: The value to insert before each item in `iterable`.
      iterable: The list into which to intersperse the separator.
    Returns:
      A new list with `separator` before each item in `iterable`.
    """
    result = []
    for x in iterable:
        result.append(separator)
        result.append(x)

    return result

def _uniq(iterable):
    """Returns a list of unique elements in `iterable`.
    Requires all the elements to be hashable.
    Args:
      iterable: An iterable to filter.
    Returns:
      A new list with all unique elements from `iterable`.
    """
    unique_elements = {element: None for element in iterable}

    # list() used here for python3 compatibility.
    # TODO(bazel-team): Remove when testing frameworks no longer require python compatibility.
    return list(unique_elements.keys())

collections = struct(
    after_each = _after_each,
    before_each = _before_each,
    uniq = _uniq,
)
```
> after_each在数组的每一个元素后面插入分隔符；before_each在每个元素后面插入分隔符；uniq利用hash数组（value为None）返回key列表的方法去重

## dicts.bzl

```python
"""Skylib module containing functions that operate on dictionaries."""

def _add(*dictionaries, **kwargs):
    """Returns a new `dict` that has all the entries of the given dictionaries.
    If the same key is present in more than one of the input dictionaries, the
    last of them in the argument list overrides any earlier ones.
    This function is designed to take zero or one arguments as well as multiple
    dictionaries, so that it follows arithmetic identities and callers can avoid
    special cases for their inputs: the sum of zero dictionaries is the empty
    dictionary, and the sum of a single dictionary is a copy of itself.
    Args:
      *dictionaries: Zero or more dictionaries to be added.
      **kwargs: Additional dictionary passed as keyword args.
    Returns:
      A new `dict` that has all the entries of the given dictionaries.
    """
    result = {}
    for d in dictionaries:
        result.update(d)
    result.update(kwargs)
    return result

def _omit(dictionary, keys):
    """Returns a new `dict` that has all the entries of `dictionary` with keys not in `keys`.
    Args:
      dictionary: A `dict`.
      keys: A sequence.
    Returns:
      A new `dict` that has all the entries of `dictionary` with keys not in `keys`.
    """
    keys_set = {k: None for k in keys}
    return {k: dictionary[k] for k in dictionary if k not in keys_set}

def _pick(dictionary, keys):
    """Returns a new `dict` that has all the entries of `dictionary` with keys in `keys`.
    Args:
      dictionary: A `dict`.
      keys: A sequence.
    Returns:
      A new `dict` that has all the entries of `dictionary` with keys in `keys`.
    """
    return {k: dictionary[k] for k in keys if k in dictionary}

dicts = struct(
    add = _add,
    omit = _omit,
    pick = _pick,
)
```
> add去除重复的key，key的value后面的覆盖前面的，还可以通过args补充字典；omit从将参数keys的key从字典中去除；pick只在字典中保留keys存在的key

## shell.bzl

```python
"""Skylib module containing shell utility functions."""

def _array_literal(iterable):
    """Creates a string from a sequence that can be used as a shell array.
    For example, `shell.array_literal(["a", "b", "c"])` would return the string
    `("a" "b" "c")`, which can be used in a shell script wherever an array
    literal is needed.
    Note that all elements in the array are quoted (using `shell.quote`) for
    safety, even if they do not need to be.
    Args:
      iterable: A sequence of elements. Elements that are not strings will be
          converted to strings first, by calling `str()`.
    Returns:
      A string that represents the sequence as a shell array; that is,
      parentheses containing the quoted elements.
    """
    return "(" + " ".join([_quote(str(i)) for i in iterable]) + ")"

def _quote(s):
    """Quotes the given string for use in a shell command.
    This function quotes the given string (in case it contains spaces or other
    shell metacharacters.)
    Args:
      s: The string to quote.
    Returns:
      A quoted version of the string that can be passed to a shell command.
    """
    return "'" + s.replace("'", "'\\''") + "'"

shell = struct(
    array_literal = _array_literal,
    quote = _quote,
)
```
> array_literal将starlark的数组转成shell的数组，非字符串的元素会被转成字符串，为了安全每个元素会加上引号，输出类似("a" "b" "c")的格式
> quote针对有空格的情况，因为空格在shell中用来分割参数的，想要在参数的内容作为整体成为shell的一个参数，需要加上引号和转义。第一个反斜杠是用来转义第二个反斜杠的，反斜杠是用来转义引号的。

## paths.bzl

Skylib有相当的内容是paython基础库的starlark重新实现。paths.bzl就是os.path的重新实现。以paths.bzl的normalize和replace_extension为例。

```python
def _normalize(path):
    """Normalizes a path, eliminating double slashes and other redundant segments.
    This function mimics the behavior of Python's `os.path.normpath` function on
    POSIX platforms; specifically:
    - If the entire path is empty, "." is returned.
    - All "." segments are removed, unless the path consists solely of a single
      "." segment.
    - Trailing slashes are removed, unless the path consists solely of slashes.
    - ".." segments are removed as long as there are corresponding segments
      earlier in the path to remove; otherwise, they are retained as leading ".."
      segments.
    - Single and double leading slashes are preserved, but three or more leading
      slashes are collapsed into a single leading slash.
    - Multiple adjacent internal slashes are collapsed into a single slash.
    Args:
      path: A path.
    Returns:
      The normalized path.
    """
    if not path:
        return "."

    if path.startswith("//") and not path.startswith("///"):
        initial_slashes = 2
    elif path.startswith("/"):
        initial_slashes = 1
    else:
        initial_slashes = 0
    is_relative = (initial_slashes == 0)

    components = path.split("/")
    new_components = []

    for component in components:
        if component in ("", "."):
            continue
        if component == "..":
            if new_components and new_components[-1] != "..":
                # Only pop the last segment if it isn't another "..".
                new_components.pop()
            elif is_relative:
                # Preserve leading ".." segments for relative paths.
                new_components.append(component)
        else:
            new_components.append(component)

    path = "/".join(new_components)
    if not is_relative:
        path = ("/" * initial_slashes) + path

    return path or "."

def _replace_extension(p, new_extension):
    """Replaces the extension of the file at the end of a path.
    If the path has no extension, the new extension is added to it.
    Args:
      p: The path whose extension should be replaced.
      new_extension: The new extension for the file. The new extension should
          begin with a dot if you want the new filename to have one.
    Returns:
      The path with the extension replaced (or added, if it did not have one).
    """
    return _split_extension(p)[0] + new_extension

def _split_extension(p):
    """Splits the path `p` into a tuple containing the root and extension.
    Leading periods on the basename are ignored, so
    `path.split_extension(".bashrc")` returns `(".bashrc", "")`.
    Args:
      p: The path whose root and extension should be split.
    Returns:
      A tuple `(root, ext)` such that the root is the path without the file
      extension, and `ext` is the file extension (which, if non-empty, contains
      the leading dot). The returned tuple always satisfies the relationship
      `root + ext == p`.
    """
    b = _basename(p)
    last_dot_in_basename = b.rfind(".")

    # If there is no dot or the only dot in the basename is at the front, then
    # there is no extension.
    if last_dot_in_basename <= 0:
        return (p, "")

    dot_distance_from_end = len(b) - last_dot_in_basename
    return (p[:-dot_distance_from_end], p[-dot_distance_from_end:])
```
replace_extension调用_split_extension方法将文件名分为后缀名之前的部分和后缀名，然后替换掉后缀名。

normalize。若path为空则返回点，判断path是否以斜杠开头断定是绝对路径还是相对路径，用斜杠将path分割成数组，若元素为空或点则去除元素，若为两个点，表示上一层目录，若前一个元素不为空且不为两个点，则可以pop前一个元素，这样可以连带..一起精简掉两个元素。
