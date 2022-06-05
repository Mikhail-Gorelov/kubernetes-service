variable "image_name" {
  description = "Please enter image name"
  type = string
  default = "centos-7"
}

variable "instance_count" {
  description = "Please enter common instance count"
  type = number
  default = 1
}

variable "allow_update" {
  description = "Please enter whether you want to allow update"
  type = bool
  default = true
}

variable "default_cores" {
  description = "Please enter default cores value"
  type = number
  default = 2
}

variable "default_memory" {
  description = "Please enter default memory value"
  type = number
  default = 2
}

variable "first_instance_name" {
  description = "Please enter first instance name"
  type = string
  default = "terraform1"
}

variable "second_instance_name" {
  description = "Please enter second instance name"
  type = string
  default = "terraform2"
}

variable "security_group_name" {
  description = "Please enter security group name"
  type = string
  default = "default"
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

variable "default_private_network" {
  description = "Please enter default private network"
  type = string
  default = "private_network"
}

variable "default_subnet_zone" {
  description = "Please enter default subnet zone"
  type = string
  default = "ru-central1-a"
}

variable "env" {
  type = string
  default = "prod"
}

variable "FOLDER" {}

variable "ZONE" {}

variable "TOKEN" {}

variable "CLOUD_ID" {}

variable "YC_CLI_FOLDER" {}
