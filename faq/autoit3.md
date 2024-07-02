# autoit3 run某些exe没有回应

有些exe会在运行时自己申请管理员权限，而有些exe不会，所以建议在脚本开头加一句：
```
#RequireAdmin
```
