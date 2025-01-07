# Ansible 变量优先级

从低到高排序：
1. 命令行参数 (例如 -u my_user)
2. role defaults (role/defaults/main.yml)
3. inventory 文件或脚本中的 group vars
4. inventory group_vars/all
5. playbook group_vars/all
6. inventory group_vars/*
7. playbook group_vars/*
8. inventory host vars
9. inventory host_vars/*
10. playbook host_vars/*
11. host facts / cached set_facts
12. play vars
13. play vars_prompt
14. play vars_files
15. role vars (role/vars/main.yml)
16. block vars (仅对 block 中的任务有效)
17. task vars (only for the task)
18. include_vars
19. set_facts / registered vars
20. extra vars (最高优先级)

## 参考文档
- Ansible 变量优先级：<https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16>
