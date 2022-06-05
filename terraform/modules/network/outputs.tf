output "subnet_id" {
  value = yandex_vpc_subnet.default_subnet.id
}

output "subnet_zone" {
  value = yandex_vpc_subnet.default_subnet.zone
}

output "network_id" {
  value = yandex_vpc_network.default_network.id
}