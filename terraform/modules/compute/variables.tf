variable "bastion_ami_id" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "bastion_security_group_id" {
  type = string
}

variable "bastion_name" {
  type = string
}

variable "app_ami_id" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "app_subnet_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}


variable "instance_profile_name" {
  type = string
}

variable "app_server_name" {
  type = string
}
