terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  type = "security group"
}

module "network" {
  source = "../../modules/network"
}

resource "yandex_vpc_address" "my_static_ip" {
  folder_id = var.folder
  name = var.static_ip_name

  external_ipv4_address {
    zone_id = var.default_static_ip_zone
  }
}

resource "yandex_vpc_security_group" "group1" {
  name        = var.security_group_name
  folder_id   = var.folder
  network_id  = module.network.network_id

  labels = merge(var.default_labels, {type = local.type})

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port      = ingress.value
      to_port        = ingress.value
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port      = 0
    to_port        = 65535
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}