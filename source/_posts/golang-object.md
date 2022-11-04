---
title: Golang面向对象的三大特性中易混淆的几个概念
readmore: true
date: 2022-11-04 13:01:06
categories: 云原生
tags:
- Golang
---

# 面向对象

篇外话：从事后端项目非前端开发，若时间有限，深入接触4门语言：c/java/go/rust，若有余力，每个语言都可以深入接触。至于Python语言，可以利用其在配置脚本领域的优势，和bash，perl一样当配置脚本语言，工具语言使用，Python不适合大型的后端项目开发。

Golang作为相对较晚出的一门语言，吸收了过往语言的不足和优点，在面向对象的三大特性，封装，继承，多态方面，自然也有不少有别于过往语言的独特设计和思想，本篇是有关golang面向对象的几个易混淆的常用的概念。

Go是否为一门面向对象的语言：是,也不是。 虽然Go语言可以通过定义类型和方法来实现面向对象的设计风格，但是Go是实际上并没有继承，类这一说法。本篇提到的golang的面向对象以及面向对象的三大特性，均省略了风格两字。

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

* 结构体相当于python，java中的类class，Text和Name相当于类中的成员变量，(a *A) Say()是A结构体变量作为方法接收器，实现了类的成员方法。这里A需要用指针A，原因在下面。
* B继承A，子类可以调用父类的方法也可以重写父类的方法实现自己的方法，Say()后面参数也实现了多态。
* A放在B结构体中用匿名方式更简洁，是推荐做法。写成a A的话，子类调用父类需要将b.A.Name改成b.a.Name
* 实现类的成员方法的方法接收器，有些人喜欢用self，this，想和python，java统一起来，我是不建议用，原因在下面。

# 方法接收器类型用结构体还是结构体指针

先要了解一件事：go语言中的结构体是值类型的，不是指针类型的。在Go语言中，除了map、slice和chan，所有类型（包括struct）都是值传递的。值传递包括函数参数传递，函数返回值赋值，其他赋值。

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

s是作为方法的接收器，s的行为就像s是方法的一个参数一样。其相当于：

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

虽然看到不少人不少地方这么用，但还是不推荐。一方面this，self是面向对象的典型标识符，golang准确是面向对象风格的，不用这些，可以做很好的区分。另一方面，上面提到过，在golang中方法接收器其实是方法的第一个参数。若不是一般写法，就是方法接收器不是结构体指针，那么不会对类中成员变量做任何修改，和this，self的意义不符，反而会误导。

推荐做法就是用小写的单个缩写字母。