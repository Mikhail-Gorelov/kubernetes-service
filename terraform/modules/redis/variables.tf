variable "namespace" {
  type = string
  default = "redis"
}

variable "helm_version" {
  type = string
  default = "16.9.2"
}

variable "values_file" {
  description = "The name of the redis helmchart values file to use"
  type        = string
  default     = "redis-values.tpl.yaml"
}

variable "replica_count" {
  type = number
  default = 1
}

variable "image_tag" {
  type = string
  default = "6.2.6"
}

variable "public_ip_address" {}