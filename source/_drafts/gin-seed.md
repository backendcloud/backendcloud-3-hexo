---
title: gin-seed 介绍
date: 2022-04-18 00:10:51
categories: Golang
tags:
- Gin
- Golang
---

# 目录结构

# token生成和校验

# 中间件

# 统一返回结构体以及自定义结构体返回

# 请求json校验
```go
func filesystemRegex(fl validator.FieldLevel) bool {
	match, _ := regexp.MatchString("ext4|xfs", fl.Field().String())
	return match
}

func BindJSONAndValidate(c *gin.Context, data interface{}) error {

	if errBind := c.BindJSON(&data); errBind != nil {
		fmt.Println(errBind)
		return errBind
	}

	validate := validator.New()
	_ = validate.RegisterValidation("filesystemRegex", filesystemRegex)

	err := validate.Struct(data)

	if err != nil {
		if _, ok := err.(*validator.InvalidValidationError); ok {
			fmt.Println(err)
			return err
		}
		for _, err := range err.(validator.ValidationErrors) {
			fmt.Println(err)
		}
		return err
	}
	return nil

}
```
# 全局统一错误码

# 日志

# main init

# 数据库

# 配置