terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.5"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

provider "docker" {
  host = "ssh://user@51.250.82.250:22"
}

resource "random_password" "root_password" {
  length  = 20
  special = false
}

resource "random_password" "wordpress_password" {
  length  = 20
  special = false
}

resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "example_${random_password.root_password.result}"

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.wordpress_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}