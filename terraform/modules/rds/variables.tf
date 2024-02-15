variable "ipv6_cidr_block" {
  type        = string
  description = "IPV6 Cidr block for the VPC"
}

variable "project_name" {
  type        = string
  default     = ""
  description = "Name used for prefix resources"
}

variable "env" {
  description = "environment used also for naming resources"
  type        = string
}

variable "db_instance_class" {
  description = "Database Instance Class"
  type        = string
  default     = "db.t4g.small"
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "admin"
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}