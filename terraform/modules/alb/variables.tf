variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "web_server_ipv6_addresses" {
  type = list(string)
}

variable "hosted_zone_id" {
  type = string
}

variable "route53_domain" {
  type = string
}


