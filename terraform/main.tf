terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

module "security" {
  source = "./modules/security"
  FOLDER = var.FOLDER
}

module "traefik" {
  source = "./modules/traefik"
  public_ip_address = yandex_kubernetes_cluster.kubernetes-services.master[0].external_v4_address
}

module "redis" {
  source = "./modules/redis"
  public_ip_address = yandex_kubernetes_cluster.kubernetes-services.master[0].external_v4_address
}

provider "yandex" {
  token = var.TOKEN
  folder_id = var.FOLDER
  cloud_id = var.CLOUD_ID
  zone = var.ZONE
}

resource "yandex_kubernetes_cluster" "kubernetes-services" {
 folder_id = var.FOLDER
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
 folder_id = var.FOLDER
 name        = "kluster-editor-puller"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 folder_id = var.FOLDER
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.default.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 folder_id = var.FOLDER
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
      security_group_ids = [module.security.security_id]
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
      zone = var.ZONE
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}