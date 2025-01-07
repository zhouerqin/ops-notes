# Windows Runas 740 错误修复

## 问题描述
使用 runas 命令时出现错误 740：请求的操作需要提升权限。

## 解决步骤
1. 右键单击目标程序的 .exe 文件
2. 选择"属性"
3. 切换到"兼容性"标签
4. 取消勾选"以管理员身份运行此程序"
5. 点击"更改所有用户的设置"
6. 在新窗口中也取消勾选"以管理员身份运行此程序"
7. 点击"确定"保存所有用户的设置
8. 点击"应用"保存修改

## 参考文档
- Windows RunAs：<https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/runas>
- UAC 和权限提升：<https://learn.microsoft.com/zh-cn/windows/security/identity-protection/user-account-control/how-user-account-control-works>
