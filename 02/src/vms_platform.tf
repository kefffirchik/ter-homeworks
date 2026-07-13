variable "vm_name_prefix" {
  type        = string
  description = "Общий префикс имен виртуальных машин"
  default     = "netology"
}

variable "vm_web_role" {
  type        = string
  description = "Назначение первой виртуальной машины"
  default     = "platform-web"
}

variable "vm_db_role" {
  type        = string
  description = "Назначение второй виртуальной машины"
  default     = "platform-db"
}

# Общие параметры ресурсов виртуальных машин

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))

  description = "Параметры ресурсов виртуальных машин"

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

# Общие параметры metadata для всех виртуальных машин

variable "metadata" {
  type = map(object({
    serial_port_enable = number
    ssh_user           = string
  }))

  description = "Общие параметры metadata виртуальных машин"

  default = {
    common = {
      serial_port_enable = 1
      ssh_user           = "ubuntu"
    }
  }
}

# Параметры первой ВМ — web

variable "vm_web_image_family" {
  type        = string
  description = "Семейство образа ОС первой ВМ"
  default     = "ubuntu-2004-lts"
}

# Переменная больше не используется: имя формируется в locals.tf
# variable "vm_web_name" {
#   type        = string
#   description = "Имя первой ВМ"
#   default     = "netology-develop-platform-web"
# }

variable "vm_web_platform_id" {
  type        = string
  description = "Аппаратная платформа первой ВМ"
  default     = "standard-v1"
}

variable "vm_web_zone" {
  type        = string
  description = "Зона доступности первой ВМ"
  default     = "ru-central1-a"
}

# Параметры объединены в переменную vms_resources
# variable "vm_web_cores" {
#   type        = number
#   description = "Количество vCPU первой ВМ"
#   default     = 2
# }

# variable "vm_web_memory" {
#   type        = number
#   description = "Объём оперативной памяти первой ВМ в ГБ"
#   default     = 1
# }

# variable "vm_web_core_fraction" {
#   type        = number
#   description = "Гарантированная доля vCPU первой ВМ"
#   default     = 5
# }

variable "vm_web_preemptible" {
  type        = bool
  description = "Прерываемость первой ВМ"
  default     = true
}

variable "vm_web_nat" {
  type        = bool
  description = "Назначение публичного IP первой ВМ"
  default     = true
}

# Параметры объединены в общую переменную metadata
# variable "vm_web_serial_port_enable" {
#   type        = number
#   description = "Включение последовательной консоли первой ВМ"
#   default     = 1
# }

# variable "vm_web_ssh_user" {
#   type        = string
#   description = "Пользователь SSH первой ВМ"
#   default     = "ubuntu"
# }

# Параметры второй ВМ — db

variable "vm_db_image_family" {
  type        = string
  description = "Семейство образа ОС второй ВМ"
  default     = "ubuntu-2004-lts"
}

# Переменная больше не используется: имя формируется в locals.tf
# variable "vm_db_name" {
#   type        = string
#   description = "Имя второй ВМ"
#   default     = "netology-develop-platform-db"
# }

variable "vm_db_platform_id" {
  type        = string
  description = "Аппаратная платформа второй ВМ"
  default     = "standard-v1"
}

variable "vm_db_zone" {
  type        = string
  description = "Зона доступности второй ВМ"
  default     = "ru-central1-b"
}

# Параметры объединены в переменную vms_resources
# variable "vm_db_cores" {
#   type        = number
#   description = "Количество vCPU второй ВМ"
#   default     = 2
# }

# variable "vm_db_memory" {
#   type        = number
#   description = "Объём оперативной памяти второй ВМ в ГБ"
#   default     = 2
# }

# variable "vm_db_core_fraction" {
#   type        = number
#   description = "Гарантированная доля vCPU второй ВМ"
#   default     = 20
# }

variable "vm_db_preemptible" {
  type        = bool
  description = "Прерываемость второй ВМ"
  default     = true
}

variable "vm_db_nat" {
  type        = bool
  description = "Назначение публичного IP второй ВМ"
  default     = true
}

# Параметры объединены в общую переменную metadata
# variable "vm_db_serial_port_enable" {
#   type        = number
#   description = "Включение последовательной консоли второй ВМ"
#   default     = 1
# }

# variable "vm_db_ssh_user" {
#   type        = string
#   description = "Пользователь SSH второй ВМ"
#   default     = "ubuntu"
# }

variable "vm_db_cidr" {
  type        = list(string)
  description = "CIDR подсети для второй ВМ"
  default     = ["10.0.2.0/24"]
}
