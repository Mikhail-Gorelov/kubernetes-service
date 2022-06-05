variable "namespace" {
  type = string
  default = "traefik"
}

variable "helm_version" {
  type = string
  default = "10.6.2"
}

variable "values_file" {
  description = "The name of the traefik helmchart values file to use"
  type        = string
  default     = "traefik-values.tpl.yaml"
}

variable "replica_count" {
  type = number
  default = 1
}

variable "image_tag" {
  type = string
  default = "2.5.4"
}

variable "public_ip_address" {}