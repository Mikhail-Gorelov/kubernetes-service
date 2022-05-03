variable "folder" {
  type = string
  default = "b1gv9hnohevov3kdhdq0"
}

variable "static_ip_name" {
  description = "Please enter static ip name"
  type = string
  default = "default"
}

variable "default_static_ip_zone" {
  description = "Please enter static ip zone"
  type = string
  default = "ru-central1-a"
}

variable "default_labels" {
  description = "Please enter default labels"
  type = map
  default = {
    name = "Mikhail"
    surname = "Gorelov"
  }
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list
  default     = ["80", "443", "22", "10000", "9000"]
}

variable "security_group_name" {
  description = "Please enter security group name"
  type = string
  default = "default"
}