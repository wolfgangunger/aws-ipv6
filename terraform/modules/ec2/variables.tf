variable "instance_type" {
  default = "t3.small"
}

variable "subnet_public_a_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "env" {
  description = "environment used also for naming resources"
  type        = string
}

variable "hosted_zone_id" {
  type = string
}

variable "route53_domain" {
  type = string
}