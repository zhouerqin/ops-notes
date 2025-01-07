# AutoIt3 运行程序无响应问题

## 问题描述
使用 Run 函数运行某些程序时没有响应，通常是因为程序需要管理员权限。

## 解决方案
在脚本开头添加管理员权限声明：
```autoit
#RequireAdmin

; 然后再运行程序
Run("yourapp.exe")
```

## 参考文档
- AutoIt3 文档：<https://www.autoitscript.com/autoit3/docs/>
- RequireAdmin：<https://www.autoitscript.com/autoit3/docs/keywords/RequireAdmin.htm>
