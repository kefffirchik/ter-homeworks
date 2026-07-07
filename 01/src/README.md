# Домашнее задание к занятию «Введение в Terraform»

## Ссылка на репозиторий

> https://github.com/kefffirchik/

---

# Задание 1

## 1. Установка Terraform

Установлена Terraform версии **1.12.1**, что соответствует требованиям задания (>=1.12.0).

### Скриншот

![Version](img/version.png)

---

## 2. В каком файле можно хранить секретные данные?

Согласно содержимому файла `.gitignore`, секретную информацию (логины, пароли, токены, ключи и т.д.) допустимо хранить в файле:

```text
personal.auto.tfvars
```

Данный файл исключён из Git и не попадёт в репозиторий.

---

## 3. Секрет из terraform.tfstate

После выполнения команды

```bash
terraform apply
```

в файле `terraform.tfstate` был найден секрет ресурса `random_password.random_string`.

**Ключ:**

```text
result
```

**Значение:**

```text
iuYpJx8sKnV5uGBQ
```

---

## 4. Ошибки после раскомментирования блока

После выполнения команды

```bash
terraform validate
```

были обнаружены следующие ошибки.

### Ошибка №1

Отсутствовало локальное имя ресурса.

Было:

```hcl
resource "docker_image" {
```

Исправлено:

```hcl
resource "docker_image" "nginx" {
```

---

### Ошибка №2

Имя ресурса начиналось с цифры.

Было:

```hcl
resource "docker_container" "1nginx" {
```

Исправлено:

```hcl
resource "docker_container" "nginx" {
```

---

### Ошибка №3

Использовалась ссылка на несуществующий ресурс.

Было:

```hcl
name = "example_${random_password.random_string_FAKE.resulT}"
```

Исправлено:

```hcl
name = "example_${random_password.random_string.result}"
```

После исправления конфигурация успешно прошла проверку.

### Скриншот

![Validate](img/validate.png)

---

## 5. Выполнение проекта

Исправленный фрагмент кода:

```hcl
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}
```

После выполнения команды

```bash
terraform apply
```

контейнер был успешно создан.

### Скриншот

![Container](img/example_cont.png)

---

## 6. Изменение имени контейнера

Имя контейнера было изменено на

```text
hello_world
```

После выполнения команды

```bash
terraform apply -auto-approve
```

контейнер был успешно пересоздан.

### Скриншот

![Hello](img/hello-cont.png)

---

### Для чего нужен ключ `-auto-approve`

По умолчанию Terraform перед применением изменений показывает план выполнения и ожидает подтверждения пользователя.

Ключ

```text
-auto-approve
```

отключает запрос подтверждения и сразу начинает применение изменений.

### Возможная опасность

Использование данного ключа может привести к случайному удалению или изменению инфраструктуры без возможности проверить план выполнения.


---

## 7. Удаление ресурсов

После выполнения команды

```bash
terraform destroy
```

Terraform успешно удалил все созданные ресурсы.

### Скриншот

![Destroy](img/destroy.png)

---

### Содержимое terraform.tfstate

После удаления ресурсов файл имеет следующий вид:

```json
{
  "version": 4,
  "terraform_version": "1.12.1",
  "serial": 11,
  "lineage": "a1dfb306-8347-f4b3-358a-b756d955fe0f",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

---

## 8. Почему Docker-образ не удалился?

В конфигурации ресурса используется параметр

```hcl
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}
```

Параметр

```text
keep_locally = true
```

указывает Terraform **не удалять Docker-образ** из локального хранилища при выполнении `terraform destroy`.

При этом Terraform удаляет ресурс из своего состояния (`terraform.tfstate`), поэтому отображается сообщение об успешном удалении ресурса.

---

### Документация Terraform Docker Provider

Для ресурса `docker_image` в документации указано:

> **keep_locally** — *If true, then the Docker image won't be deleted on destroy operation.*


---

# Задание 2*

Не выполнялось.

---

# Задание 3*

Не выполнялось.
