terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket = "kubernetes-bucket"
    key    = "dev/kubernetes-services/terraform.tfstate"
    region     = "ru-central1-a"
    access_key = "YCAJEdGyk0aWtgvvWQUPq1Sj2"
    secret_key = "YCN97QI8mUwu5DcWn9ixtNlsCftZkGgMoJXZdkmt"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
  required_version = ">= 0.13"
}

module "security" {
  source = "./modules/security"
}

provider "yandex" {
  token = var.token
}

resource "yandex_kubernetes_cluster" "kubernetes-services" {
 folder_id = var.folder
 network_id = module.security.network_id
 master {
   zonal {
     zone      = module.security.subnet_zone
     subnet_id = module.security.subnet_id
   }
   public_ip = true
 }
 service_account_id      = yandex_iam_service_account.default.id
 node_service_account_id = yandex_iam_service_account.default.id
   depends_on = [
     yandex_resourcemanager_folder_iam_binding.editor,
     yandex_resourcemanager_folder_iam_binding.images-puller
   ]
}

resource "yandex_iam_service_account" "default" {
 folder_id = var.folder
 name        = "kluster-editor-puller"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 folder_id = var.folder
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.default.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 folder_id = var.folder
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.default.id}"
 ]
}

resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = "${yandex_kubernetes_cluster.kubernetes-services.id}"
  name        = "node-group"
  version     = "1.20"

  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat                = true
      subnet_ids         = [module.security.subnet_id]
    }

    resources {
      memory = 4
      cores  = 4
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "docker"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}

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