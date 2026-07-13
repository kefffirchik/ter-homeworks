###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}

# Параметры образа виртуальной машины

variable "vm_web_image_family" {
  type        = string
  description = "Семейство образов операционной системы для web-сервера"
  default     = "ubuntu-2004-lts"
}

# Параметры виртуальной машины

variable "vm_web_name" {
  type        = string
  description = "Имя виртуальной машины web-сервера"
  default     = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type        = string
  description = "Идентификатор аппаратной платформы web-сервера"
  default     = "standard-v1"
}

variable "vm_web_cores" {
  type        = number
  description = "Количество виртуальных процессорных ядер web-сервера"
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  description = "Объём оперативной памяти web-сервера в ГБ"
  default     = 1
}

variable "vm_web_core_fraction" {
  type        = number
  description = "Гарантированная доля производительности vCPU web-сервера"
  default     = 5
}

variable "vm_web_preemptible" {
  type        = bool
  description = "Признак прерываемой виртуальной машины"
  default     = true
}

variable "vm_web_nat" {
  type        = bool
  description = "Назначение публичного IP-адреса web-серверу"
  default     = true
}

variable "vm_web_serial_port_enable" {
  type        = number
  description = "Включение последовательной консоли виртуальной машины"
  default     = 1
}

variable "vm_web_ssh_user" {
  type        = string
  description = "Имя пользователя для подключения к web-серверу по SSH"
  default     = "ubuntu"
}
