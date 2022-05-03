terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_vpc_network" "default_network" {
  folder_id = var.folder
}

resource "yandex_vpc_subnet" "default_subnet" {
  folder_id = var.folder
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = var.default_subnet_zone
  network_id     = yandex_vpc_network.default_network.id
}