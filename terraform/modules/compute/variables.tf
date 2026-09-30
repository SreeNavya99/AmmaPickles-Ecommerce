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

variable "nexus_ami_id" {
  description = "AMI ID for the Nexus server"
  type        = string
}

variable "nexus_instance_type" {
  description = "EC2 instance type for the Nexus server"
  type        = string
}

variable "nexus_subnet_id" {
  description = "Subnet ID for the Nexus server"
  type        = string
}

variable "nexus_security_group_id" {
  description = "Security group ID for the Nexus server"
  type        = string
}

variable "nexus_root_volume_size" {
  description = "Root volume size for the Nexus server in GiB"
  type        = number
}

variable "nexus_server_name" {
  description = "Name of the Nexus server"
  type        = string
}
