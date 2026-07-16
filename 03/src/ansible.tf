resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web
    databases  = values(yandex_compute_instance.db)
    storage    = [yandex_compute_instance.storage]
  })

  filename = "${path.module}/hosts.ini"
}

resource "null_resource" "ansible_provision" {
  depends_on = [
    local_file.ansible_inventory,
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage
  ]

  triggers = {
    inventory = local_file.ansible_inventory.content_sha256
    playbook  = filesha256("${path.module}/test.yml")
  }

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i ${local_file.ansible_inventory.filename} \
        ${path.module}/test.yml \
        --private-key ~/.ssh/id_ed25519 \
        -u ubuntu
    EOT
  }
}
