locals {
  prefix = "${var.prefix}-argo-tunnel"
  common_tags = merge(
    var.common_tags,
    {
      "stack" = "argo-tunnel"
    },
  )
}

# Common
variable "prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

# EC2
variable "instance_type" {
  type    = string
  default = "t3.small"
}

# Network
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

# Cloudflare
variable "cloudflare_zone_id" {
  type = string
}

# Internal services
# My service
variable "my_service_url" {
  default = "https://my-internal-service-url.com/"
  type    = string
}

variable "my_service_domain" {
  default = "my-service-public-domain"
  type    = string
}

variable "my_service_hostname" {
  default = "my-service-public-domain.my-domain.com"
  type = string
}
