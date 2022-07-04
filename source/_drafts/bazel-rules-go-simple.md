---
title: bazel-rules-go-simple
readmore: true
date: 2022-07-04 18:22:21
categories: Devops
tags:
- Bazel
---

go
bug         start a bug report
build       compile packages and dependencies
clean       remove object files and cached files
doc         show documentation for package or symbol
env         print Go environment information
fix         update packages to use new APIs
fmt         gofmt (reformat) package sources
generate    generate Go files by processing source
get         add dependencies to current module and install them
install     compile and install packages and dependencies
list        list packages or modules
mod         module maintenance
run         compile and run Go program
test        test packages
tool        run specified go tool
version     print Go version
vet         report likely mistakes in packages

go tool
go tool asm file 将go汇编文件编译为 object（.o） 文件。
go tool compile file 将go文件编译为 .o 文件。
go tool compile -N -l -S file 将文件编译为汇编代码
或者使用：go build -gcflags -S x.go
gcflags == go compile flags
go tool compile：处理go文件，执行词法分析、语法分析、汇编、编译，输出obj文件
go tool asm：处理汇编文件（.s文件），输出obj文件
go tool pack：打包package下的所有obj文件，输出.a文件
go tool link：链接不同package的.a文件，输出可执行文件
go tool objdump：反汇编obj文件
go tool nm：输出obj文件、.a文件或可执行文件中定义的符号

tool link	link（通常作为“go tool link”调用）读取包主目录的Go归档文件或对象及其依赖项，并将其组合到可执行二进制文件中。