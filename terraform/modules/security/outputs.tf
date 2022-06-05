output "webserver_public_ip_connection" {
  value = yandex_vpc_address.my_static_ip.external_ipv4_address
}

output "security_id" {
  value = yandex_vpc_security_group.group1.id
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "subnet_zone" {
  value = module.network.subnet_zone
}

output "network_id" {
  value = module.network.network_id
}