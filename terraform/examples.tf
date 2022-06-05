#data "yandex_compute_image" "centos_image" {
#  family = "centos-7"
#}
#resource "yandex_compute_instance" "web" {
#  zone = var.zone
#  folder_id = var.folder
#  count = var.instance_count
#  name = var.first_instance_name
#  allow_stopping_for_update = var.allow_update
#  depends_on = [yandex_compute_instance.database]
#
#  resources {
#    cores  = (var.env == "dev" ? var.default_cores : 4)
#    memory = (var.env == "dev" ? var.default_memory : 4)
#  }
#
#  lifecycle {
#    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
#    create_before_destroy = true
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = data.yandex_compute_image.centos_image.id
#    }
#  }
#
#  network_interface {
#    subnet_id = module.security.subnet_id
#    security_group_ids = [module.security.security_id]
#  }
#
#  metadata = {
#    user-data = "${templatefile("user-data.tpl.sh", {
#        f_name="Mikhail",
#        l_name="Gorelov",
#        names=["Vasya", "Petya"]
#    })}"
#  }
#}
#resource "yandex_compute_instance" "database" {
#  zone = var.zone
#  folder_id = var.folder
#  count = var.instance_count
#  name = var.second_instance_name
#  allow_stopping_for_update = var.allow_update
#
#  resources {
#    cores  = (var.env == "dev" ? var.default_cores : 4)
#    memory = (var.env == "dev" ? var.default_memory : 4)
#  }
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = data.yandex_compute_image.centos_image.id
#    }
#  }
#
#  network_interface {
#    subnet_id = module.security.subnet_id
#    security_group_ids = [module.security.security_id]
#  }
#
#}