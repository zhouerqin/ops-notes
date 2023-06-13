# ansible中变量的优先级
Understanding variable precedence

Ansible does apply variable precedence, and you might have a use for it. Here is the order of precedence from least to greatest (the last listed variables override all other variables):

1. command line values (for example, , these are not variables)-u my_user
1. role defaults (defined in role/defaults/main.yml) 1
1. inventory file or script group vars 2
1. inventory group_vars/all 3
1. playbook group_vars/all 3
1. inventory group_vars/* 3
1. playbook group_vars/* 3
1. inventory file or script host vars 2
1. inventory host_vars/* 3
1. playbook host_vars/* 3
1. host facts / cached set_facts 4
1. play vars
1. play vars_prompt
1. play vars_files
1. role vars (defined in role/vars/main.yml)
1. block vars (only for tasks in block)
1. task vars (only for the task)
1. include_vars
1. set_facts / registered vars
1. role (and include_role) params
1. include params
1. extra vars (for example, )(always win precedence)-e "user=my_user"

<https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16>
