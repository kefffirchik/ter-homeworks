# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

## Задание 1

### Выполнение задания

В рамках задания был развернут стенд в Yandex Cloud с помощью Terraform.

Были выполнены следующие действия:

- создана сеть VPC;
- создана подсеть;
- создана виртуальная машина Ubuntu;
- настроен доступ по SSH через публичный ключ;
- выполнено подключение к виртуальной машине;
- проверен внешний IP с помощью команды `curl ifconfig.me`.

---

## Исправленные ошибки

Во время выполнения задания были обнаружены и исправлены ошибки в исходной конфигурации.

### Ошибка №1

В параметре

```hcl
platform_id = "standart-v4"
```

была допущена опечатка.

Вместо

```text
standart
```

должно быть

```text
standard
```

Из-за этой ошибки API Yandex Cloud возвращал сообщение:

```text
Platform "standart-v4" not found
```

---

### Ошибка №2

После исправления названия платформы выяснилось, что выбранная платформа не поддерживает значение

```hcl
core_fraction = 5
```

Для сохранения параметра `core_fraction = 5` была выбрана совместимая платформа:

```hcl
platform_id = "standard-v1"
```

---

### Ошибка №3

Платформа `standard-v1` не поддерживает создание виртуальной машины с одним виртуальным ядром.

Исходное значение:

```hcl
cores = 1
```

было изменено на

```hcl
cores = 2
```

После этого виртуальная машина была успешно создана.

---

## Подключение к виртуальной машине

Подключение выполнялось командой:

```bash
ssh ubuntu@93.77.180.40
```

Проверка внешнего IP:

```bash
curl ifconfig.me
```

Результат:

```text
93.77.180.40
```

IP полностью совпадает с публичным адресом виртуальной машины в Yandex Cloud.

---

## Ответы на вопросы

### Для чего используется `preemptible = true`

Параметр

```hcl
preemptible = true
```

создает прерываемую виртуальную машину.

Такие ВМ значительно дешевле обычных и хорошо подходят для:

- лабораторных работ;
- обучения;
- тестирования;
- временных стендов.

Недостаток заключается в том, что Yandex Cloud может остановить такую виртуальную машину в любой момент.

---

### Для чего используется `core_fraction = 5`

Параметр

```hcl
core_fraction = 5
```

определяет гарантированную производительность процессора.

Значение `5` означает, что виртуальная машина получает гарантированные 5% производительности каждого vCPU.

Это позволяет существенно снизить стоимость виртуальной машины, что особенно удобно при выполнении учебных заданий и запуске сервисов с небольшой нагрузкой.

---

# Скриншоты

## Виртуальная машина в Yandex Cloud

![VM](img/task1/yc-vm.png)

---

## Проверка внешнего IP

![curl](img/task1/curl.png)

---

# Задание 2

## Замена хардкод-значений на переменные

Выполнены следующие изменения:

- все хардкод-значения в ресурсе `yandex_compute_instance` вынесены в переменные;
- значение семейства образов в `yandex_compute_image` также вынесено в отдельную переменную;
- все переменные, относящиеся к виртуальной машине, получили префикс `vm_web_`;
- для всех переменных указан тип (`string`, `number`, `bool`);
- значения `default` соответствуют исходным значениям конфигурации.

### Используемые переменные

| Переменная | Значение по умолчанию |
|------------|----------------------:|
| `vm_web_name` | `netology-develop-platform-web` |
| `vm_web_platform_id` | `standard-v1` |
| `vm_web_image_family` | `ubuntu-2004-lts` |
| `vm_web_cores` | `2` |
| `vm_web_memory` | `1` |
| `vm_web_core_fraction` | `5` |
| `vm_web_preemptible` | `true` |
| `vm_web_nat` | `true` |
| `vm_web_serial_port_enable` | `1` |
| `vm_web_ssh_user` | `ubuntu` |

---

## Проверка Terraform

После замены всех хардкод-значений была выполнена проверка:

```bash
terraform plan
```

Результат:

```text
No changes. Your infrastructure matches the configuration.
```

Это подтверждает, что перенос значений в переменные не изменил существующую инфраструктуру.

---

# Задание 3

## Создание второй виртуальной машины

Для переменных виртуальных машин был создан отдельный файл:

```text
vms_platform.tf
```

В него были перенесены переменные первой ВМ с префиксом:

```text
vm_web_
```

Для второй ВМ были объявлены отдельные переменные с префиксом:

```text
vm_db_
```

В файле `main.tf` была создана вторая виртуальная машина:

```text
netology-develop-platform-db
```

Параметры второй ВМ:

```hcl
name          = "netology-develop-platform-db"
zone          = "ru-central1-b"
cores         = 2
memory        = 2
core_fraction = 20
```

Так как ВМ размещается в зоне `ru-central1-b`, для неё была создана отдельная подсеть:

```text
develop-db
```

с адресным диапазоном:

```text
10.0.2.0/24
```

## Проверка плана

Перед применением изменений была выполнена команда:

```bash
terraform plan
```

Результат:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

Terraform планировал создать:

- новую подсеть в зоне `ru-central1-b`;
- вторую виртуальную машину.

Первая ВМ при этом не изменялась и не пересоздавалась.

## Результат применения

После выполнения:

```bash
terraform apply
```

были успешно созданы две виртуальные машины:

```text
netology-develop-platform-db  - ru-central1-b
netology-develop-platform-web - ru-central1-a
```

Проверка через Yandex Cloud CLI:

```text
+----------------------+-------------------------------+---------------+---------+----------------+-------------+
|          ID          |             NAME              |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+-------------------------------+---------------+---------+----------------+-------------+
| epdec8bt6ag3f2p8972g | netology-develop-platform-db  | ru-central1-b | RUNNING | 84.252.139.233 | 10.0.2.16   |
| fhmtu3sn584a2j4ktbcs | netology-develop-platform-web | ru-central1-a | RUNNING | 93.77.180.40   | 10.0.1.16   |
+----------------------+-------------------------------+---------------+---------+----------------+-------------+
```

Параметры второй ВМ были дополнительно проверены через Terraform State:

```text
name          = "netology-develop-platform-db"
zone          = "ru-central1-b"
core_fraction = 20
cores         = 2
memory        = 2
```

---

# Задание 4

## Создание output-переменной

В файле `outputs.tf` был объявлен один output `vms_info`, содержащий информацию о каждой виртуальной машине:

- имя экземпляра (`instance_name`);
- внешний IP-адрес (`external_ip`);
- внутренний FQDN (`fqdn`).

Конфигурация output:

```hcl
output "vms_info" {
  description = "Информация о созданных виртуальных машинах"

  value = {
    web = {
      instance_name = yandex_compute_instance.platform.name
      external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform.fqdn
    }

    db = {
      instance_name = yandex_compute_instance.platform_db.name
      external_ip   = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform_db.fqdn
    }
  }
}
```

Все значения получаются из атрибутов ресурсов Terraform, без использования хардкода.

## Проверка

После применения изменений была выполнена команда:

```bash
terraform output
```

Результат:

```text
vms_info = {
  "db" = {
    "external_ip" = "84.252.139.233"
    "fqdn" = "epdec8bt6ag3f2p8972g.auto.internal"
    "instance_name" = "netology-develop-platform-db"
  }
  "web" = {
    "external_ip" = "93.77.180.40"
    "fqdn" = "fhmtu3sn584a2j4ktbcs.auto.internal"
    "instance_name" = "netology-develop-platform-web"
  }
}
```

---

# Задание 5

## Использование локальных значений

В файле `locals.tf` был создан один блок `locals`, в котором формируются имена обеих виртуальных машин:

```hcl
locals {
  vm_web_name = "${var.vm_name_prefix}-${var.vpc_name}-${var.vm_web_role}"
  vm_db_name  = "${var.vm_name_prefix}-${var.vpc_name}-${var.vm_db_role}"
}
```

Для формирования каждого имени используется интерполяция `${...}` с несколькими переменными.

В ресурсах виртуальных машин значения `name` были заменены на локальные значения:

```hcl
name = local.vm_web_name
```

и

```hcl
name = local.vm_db_name
```

После изменений была выполнена проверка:

```bash
terraform plan
```

Результат:

```text
No changes. Your infrastructure matches the configuration.
```

Это подтверждает, что имена ВМ формируются через `locals`, но сами значения остались прежними.

---

# Задание 6

## Объединение параметров ВМ в map(object)

Параметры ресурсов обеих виртуальных машин были объединены в одну переменную `vms_resources` типа `map(object)`:

```hcl
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))

  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }

    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}
```

В ресурсах виртуальных машин параметры используются через вложенные значения:

```hcl
resources {
  cores         = var.vms_resources.web.cores
  memory        = var.vms_resources.web.memory
  core_fraction = var.vms_resources.web.core_fraction
}
```

Для второй ВМ:

```hcl
resources {
  cores         = var.vms_resources.db.cores
  memory        = var.vms_resources.db.memory
  core_fraction = var.vms_resources.db.core_fraction
}
```

## Общая переменная metadata

Для обеих ВМ была создана единая переменная `metadata` типа `map(object)`:

```hcl
variable "metadata" {
  type = map(object({
    serial_port_enable = number
    ssh_user           = string
  }))

  default = {
    common = {
      serial_port_enable = 1
      ssh_user           = "ubuntu"
    }
  }
}
```

В обеих ВМ используется одинаковый блок:

```hcl
metadata = {
  serial-port-enable = var.metadata.common.serial_port_enable
  ssh-keys           = "${var.metadata.common.ssh_user}:${var.vms_ssh_root_key}"
}
```

Более не используемые переменные были закомментированы.

## Проверка

После изменений была выполнена команда:

```bash
terraform plan
```

Результат:

```text
No changes. Your infrastructure matches the configuration.
```

Это подтверждает, что рефакторинг переменных не изменил существующую инфраструктуру.

---


