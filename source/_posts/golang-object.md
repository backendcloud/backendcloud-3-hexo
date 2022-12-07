---
title: Golang面向对象中易混淆的几个概念
readmore: true
date: 2022-11-04 13:01:06
categories: 云原生
tags:
- Golang
---

# 面向对象的三大特性

篇外话：从事云计算后端项目非前端开发，若时间有限，值得深入接触的编程语言有4门：c/java/go/rust，若有余力，每个语言都可以深入接触。至于Python语言，可以利用其在配置脚本领域的优势，和bash，perl一样当配置脚本语言，工具语言使用，Python不太适合大型的后端项目开发。

Golang作为相对较晚出的一门语言，吸收了过往语言的不足和优点，在面向对象的三大特性，封装，继承，多态方面，自然也有不少有别于过往语言的独特设计和思想，本篇是有关golang面向对象的几个易混淆的常用的概念。

Go是否为一门面向对象的语言：是，也不是。 虽然Go语言可以通过定义类型和方法来实现面向对象的设计风格，但是Go是实际上并没有继承，类这一说法。本篇提到的golang的面向对象以及面向对象的三大特性，均省略了风格两字。

首先和python基本的面向对象的一段程序做个对比：

```python
# 创建父类学校成员SchoolMember
class SchoolMember:

    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def tell(self):
        # 打印个人信息
        print('Name:"{}" Age:"{}"'.format(self.name, self.age), end=" ")


# 创建子类老师 Teacher
class Teacher(SchoolMember):

    def __init__(self, name, age, salary):
        super().__init__(self, name, age) # 利用父类进行初始化
        self.salary = salary
    
    # 方法重写
    def tell(self):
        super().tell(self)
        print('Salary: {}'.format(self.salary))


# 创建子类学生Student
class Student(SchoolMember):

    def __init__(self, name, age, score):
        super().__init__(self, name, age)
        self.score = score
    
    def tell(self):
        super().tell(self)
        print('score: {}'.format(self.score))


teacher1 = Teacher("John", 44, "$60000")
student1 = Student("Mary", 12, 99)

teacher1.tell()  # 打印 Name:"John" Age:"44" Salary: $60000
student1.tell()  # Name:"Mary" Age:"12" score: 99
```

```go
type A struct {
    Text string
    Name string
}
 
func (a *A) Say() {
    fmt.Printf("A::Say():%s\n", a.Text)
}
 
type B struct {
    A
    Name string
}
 
func (b *B) Say() {
    b.A.Say()
    fmt.Printf("B::Say():%s\n", b.Text)
}
 
func main() {
    b := B{A{"hello, world", "张三"}, "李四"}
 
    b.Say()
    fmt.Println("b的名字为：", b.Name)
 
    // 如果要显示 B 的 Name 值
    fmt.Println("b的名字为：", b.A.Name)
}
```

* 结构体相当于python，java中的类class，Text和Name相当于类中的成员变量，(a *A) Say()中的a是A结构体变量作为方法接收器，实现了类的成员方法。这里A一般用指针A，原因在下面。
* B继承A，子类可以调用父类的方法也可以重写父类的方法实现自己的方法，Say()后面写不同的参数就实现了多态。
* A放在B结构体中用匿名方式更简洁，是推荐做法。写成a A的话，子类调用父类需要将b.A.Name改成b.a.Name
* 实现类的成员方法的方法接收器，有些人喜欢用self，this，想和python，java统一起来，我是不建议用，原因在下面。
* 一叶而知秋，从面向对象的实现上的对比就看出来了，go开发效率太高了，开发太灵活了。一般人接触过go后，今后的项目能用go开发的都优先用go。

# 方法接收器类型用结构体还是结构体指针

先要了解一件事：go语言中的结构体是值类型的，不是指针类型的。在Go语言中，除了map、slice和chan，所有类型（包括struct）都是值传递的。值传递包括函数参数传递，函数返回值赋值，其他赋值都是值传递。

明白这一点，下面的代码就很好理解：

```go
type person struct {
    name string
    age int
}

// newPerson 返回一个结构体变量
func newPerson(name string,age int) person{
	ret := person{
		name: name,
		age: age,
	}
    // 在创建结构体时，返回其内存地址
	fmt.Printf("%p\n",&ret)
	return  ret
}

// newPerson2 返回一个结构体指针
func newPerson2(name string,age int) *person{
	ret := &person{
		name: name,
		age: age,
	}
    // 在创建结构体指针时，返回他储存的结构体的地址
	fmt.Printf("%p\n",ret)
	return ret
}

func main(){
    p1 := newPerson("张三", 1)
    fmt.Printf("%p\n", &p1)
    p2 := newPerson2("李四", 2)
    fmt.Printf("%p\n", p2)
	    
}
// // 以下是调用构造函数newPerson时，返回的结构体变量的地址
// 0xc000096460
// // 以下是调用构造函数newPerson时，创建的结构体实例的地址
// 0xc000096440
// // 以下是调用构造函数newPerson2时，返回的结构体指针的地址
// 0xc0000964a0
// // 以下是调用构造函数newPerson2时，创建的结构体指针的地址
// 0xc0000964a0
```

理解了上面的内容，就可以理解最上面的代码中(a *A) Say()实现了类的成员方法，只能用`*A`，不能用A。

先看下面的代码：

```go
type MyStruct struct {
    Name string
}

func (s MyStruct) SetName1(name string) {
    s.Name = name
}

func (s *MyStruct) SetName2(name string) {
    s.Name = name
}
```

s是作为方法的接收器，s的行为就像s是方法的第一个参数一样。其相当于：

> 篇外话：并不是只有结构体才能绑定方法，任何类型都可以绑定方法，只是我们这里介绍将方法绑定到结构体中。

```go
func SetName1(s MyStruct, name string){
   s.Name = name
}

func SetName2(s *MyStruct,name string){
   s.Name = name
}
```

这样就很好理解了，为何，要写成类的成员方法一般用结构体指针类型。结构体方法是要将接收器定义成值，还是指针。这本质上与函数参数应该是值还是指针是同一个问题。

# 方法接收器为何不推荐用this，self

虽然看到不少人不少地方这么用，但还是不推荐。一方面this，self是面向对象的典型标识符，golang准确是面向对象风格的，不用这些，可以做很好的区分。另一方面，上面提到过，在golang中方法接收器其实是方法的第一个参数。若不是一般写法，就是方法接收器不是结构体指针，而是结构体的情形，那么不会对类中成员变量做任何修改，和this，self的意义完全不符，这时候用this，self会带到沟里去。

推荐做法就是用小写的单个缩写字母或多个缩写字母。

# 类的声明和初始化时候的内存分配问题

前面提到，在Go语言中，除了map、slice和chan，所有类型（包括struct）都是值传递的。map在文章{% post_link golang-map %}提到：

```go
	// var countryCapitalMap map[string]string
	// //countryCapitalMap = make(map[string]string)
	// countryCapitalMap [ "France" ] = "巴黎"
	// 若不加中间这句make，会报错
```

因为map是指针传递，不是值传递，var countryCapitalMap map[string]string，后直接新增key是会panic的，是因为还没有为这个map分配内存空间，加入key/value会panic。因为map是指针传递的，这种写法仅仅是声明不会完成初始化，会有panic的问题；若是值传递，这样的写法，是声明的同时完成对应数据类型的零值的初始化，就不会有此类panic的问题。

同理，结构体是值传递，但值传递的类型的指针是指针传递的，所以结构体指针是指针传递的。所以：

```go
var m1 Member
m1.name = "小明" //正确用法，结构体字段初始化对应类型的零值

var m1 *Member
m1.name = "小明"//错误用法，未初始化,m1为nil

m1 = &Member{}
m1.name = "小明"//初始化后，结构体指针指向某个结构体地址，才能访问字段，为字段赋值。 
```

另外，使用Go内置new()函数，可以分配内存来初始化结构休，并返回分配的内存指针，因为已经初始化了，所以可以直接访问字段。

```go
var m2 = new(Member)
m2.name = "小红"
```

# 类的成员变量的公有和私有问题

```go
package member
type Member struct {
    id     int
    name   string
    email  string
    gender int
    age    int
}

package main

fun main(){
    var m = member.Member{1,"小明","xiaoming@163.com",1,18}//会引发panic错误
}
```

由于结构体的字段包外不可见，因此无法为字段赋初始值，无法按字段还是按索引赋值，都会引发panic错误。因此，如果想在一个包中访问另一个包中结构体的字段，则必须是大写字母开头的变量，即可导出的变量。这和python中用两个下划线，java中用private关键字的形式不同。

# 总结

本篇主要讲了结构体实现其他语言的类风格，继承风格（在Go语言中也没有继承的概念，Go语言的编程哲学里，推荐使用组合（组合，可以理解为定义一个结构体中，其字段可以是其他的结构体，这样，不同的结构体就可以共用相同的字段。）的方式来达到代码复用效果。（另外，结构体不能包含自身，但可能包含指向自身的结构体指针。）），值传递和指针传递在结构体的应用，方法接收器，结构体的声明和初始化，一起共同实现golang的面向对象风格编程。