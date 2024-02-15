variable "project_name" {
  type        = string
  default     = ""
  description = "Name used for prefix resources"
}

variable "owner" {
  description = "Owner name for tag resources"
  type        = string
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "class_B" {
  type        = number
  default     = 100
  description = "Class B of VPC (10.XXX.0.0/16)"
}

variable "env" {
  description = "environment used also for naming resources"
  type        = string
}