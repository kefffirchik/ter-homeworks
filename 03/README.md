# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

## Задание 1

Проект был инициализирован и успешно применён.

Использованные команды:

```bash
terraform init
terraform plan
terraform apply
```

В результате были созданы:

- VPC-сеть `develop`;
- подсеть `develop`;
- группа безопасности `example_dynamic`.

В группе безопасности настроены следующие входящие правила:

| Протокол | Порт | Источник |
|----------|-----:|----------|
| TCP | 22 | `0.0.0.0/0` |
| TCP | 80 | `0.0.0.0/0` |
| TCP | 443 | `0.0.0.0/0` |

### Скриншот

![Входящие правила группы безопасности](img/secgr.png)

---

## Задание 2

### ВМ с использованием `count`

В файле `count-vm.tf` описано создание двух одинаковых виртуальных машин:

- `web-1`;
- `web-2`.

Для создания ВМ используется мета-аргумент:

```hcl
count = 2
```

Имена формируются выражением:

```hcl
name = "web-${count.index + 1}"
```

Благодаря добавлению `1` к `count.index` виртуальные машины получают имена `web-1` и `web-2`.

К обеим виртуальным машинам подключена группа безопасности, созданная в задании 1:

```hcl
security_group_ids = [
  yandex_vpc_security_group.example.id
]
```

### ВМ с использованием `for_each`

В файле `for_each-vm.tf` описано создание двух виртуальных машин для баз данных:

- `main`;
- `replica`.

Параметры ВМ задаются общей переменной `each_vm`:

```hcl
variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))

  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2
      disk_volume = 10
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 4
      disk_volume = 15
    }
  ]
}
```

Для использования списка в `for_each` он преобразуется в map:

```hcl
for_each = {
  for vm in var.each_vm : vm.vm_name => vm
}
```

В результате создаются ресурсы:

```text
yandex_compute_instance.db["main"]
yandex_compute_instance.db["replica"]
```

### Зависимость между ВМ

Виртуальные машины `web-1` и `web-2` создаются после ВМ `main` и `replica`.

Для этого используется явная зависимость:

```hcl
depends_on = [
  yandex_compute_instance.db
]
```

### Использование SSH-ключа

Публичный SSH-ключ считывается функцией `file` в локальную переменную:

```hcl
locals {
  ssh_public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}
```

Ключ передаётся в metadata виртуальных машин:

```hcl
metadata = {
  ssh-keys = "ubuntu:${local.ssh_public_key}"
}
```

### Результат выполнения

Конфигурация была проверена командой:

```bash
terraform validate
```

Результат:

```text
Success! The configuration is valid.
```

После применения конфигурации были созданы четыре виртуальные машины:

```text
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

---

