variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDR blocks"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "nat_eip_count" {
  description = "Number of NAT gateway EIPs"
  type        = number
}

variable "bastion_ami_id" {
  description = "AMI ID for bastion host"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
}

variable "ec2_key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "bastion_ssh_cidr" {
  description = "CIDR allowed to SSH to bastion"
  type        = string
}

variable "app_ami_id" {
  description = "AMI ID for application server"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type for application server"
  type        = string
}

variable "rds_identifier" {
  description = "RDS DB instance identifier"
  type        = string
}

variable "rds_engine" {
  description = "RDS database engine"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS database engine version"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_allocated_storage" {
  description = "Initial RDS storage in GiB"
  type        = number
}

variable "rds_max_allocated_storage" {
  description = "Maximum RDS storage in GiB"
  type        = number
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
}

variable "rds_multi_az" {
  description = "Whether RDS Multi-AZ is enabled"
  type        = bool
}

variable "rds_backup_retention_period" {
  description = "RDS automated backup retention period"
  type        = number
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip final snapshot on deletion"
  type        = bool
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
