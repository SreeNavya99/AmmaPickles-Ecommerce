variable "aws_region" {
  description = "AWS region for Amma Pickles infrastructure"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDRs for private application subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDRs for private database subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones used by the project"
  type        = list(string)
}

variable "bastion_ssh_cidr" {
  description = "Public IP CIDR allowed to SSH to the bastion"
  type        = string
}

variable "ec2_key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion instance type"
  type        = string
}

variable "app_instance_type" {
  description = "Application/DevOps server instance type"
  type        = string
}

variable "app_ami_id" {
  description = "AMI ID for the application/DevOps EC2"
  type        = string
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion EC2"
  type        = string
}

variable "nat_eip_count" {
  description = "Number of EIPs associated with the existing NAT architecture"
  type        = number
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "eks_node_group_name" {
  description = "EKS managed node group name"
  type        = string
}

variable "eks_node_instance_types" {
  description = "EKS worker node instance types"
  type        = list(string)
}

variable "eks_node_desired_size" {
  description = "Desired number of EKS nodes"
  type        = number
}

variable "eks_node_min_size" {
  description = "Minimum number of EKS nodes"
  type        = number
}

variable "eks_node_max_size" {
  description = "Maximum number of EKS nodes"
  type        = number
}

variable "eks_node_disk_size" {
  description = "EKS worker root disk size in GiB"
  type        = number
}

variable "rds_identifier" {
  description = "Existing RDS DB instance identifier"
  type        = string
}

variable "rds_engine" {
  description = "RDS engine"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GiB"
  type        = number
}

variable "rds_db_name" {
  description = "Initial RDS database name"
  type        = string
  default     = null
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
  default     = null
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  default     = null
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention period"
  type        = number
}

variable "rds_multi_az" {
  description = "Whether RDS Multi-AZ is enabled"
  type        = bool
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip the final RDS snapshot when destroying"
  type        = bool
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN used by the EKS managed node group"
  type        = string
}

variable "nat_gateway_id" {
  description = "Existing regional NAT Gateway ID"
  type        = string
}
