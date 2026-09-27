variable "vpc_id" {
  description = "VPC ID where the security groups are created"
  type        = string
}

variable "bastion_name" {
  type = string
}

variable "bastion_description" {
  type = string
}

variable "bastion_ssh_cidr" {
  type = string
}

variable "app_name" {
  type = string
}

variable "app_description" {
  type = string
}

variable "alb_name" {
  type = string
}

variable "alb_description" {
  type = string
}

variable "rds_name" {
  type = string
}

variable "rds_description" {
  type = string
}
