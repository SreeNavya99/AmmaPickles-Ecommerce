variable "project_name" {
  description = "Project name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDRs"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDRs"
  type        = list(string)
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "internet_gateway_name" {
  description = "Internet Gateway name"
  type        = string
}

variable "public_route_table_name" {
  description = "Public route table name"
  type        = string
}

variable "private_route_table_name" {
  description = "Private application route table name"
  type        = string
}

variable "db_route_table_name" {
  description = "Private database route table name"
  type        = string
}

variable "nat_gateway_id" {
  description = "Existing regional NAT Gateway ID"
  type        = string
}

variable "nat_eip_count" {
  description = "Number of NAT EIPs"
  type        = number
}

variable "bastion_sg_name" {
  description = "Bastion security group name"
  type        = string
}

variable "bastion_sg_description" {
  description = "Bastion security group description"
  type        = string
}

variable "bastion_ssh_cidr" {
  description = "CIDR allowed to SSH to bastion"
  type        = string
}

variable "app_sg_name" {
  description = "Application security group name"
  type        = string
}

variable "app_sg_description" {
  description = "Application security group description"
  type        = string
}

variable "alb_sg_name" {
  description = "ALB security group name"
  type        = string
}

variable "alb_sg_description" {
  description = "ALB security group description"
  type        = string
}

variable "rds_sg_name" {
  description = "RDS security group name"
  type        = string
}

variable "rds_sg_description" {
  description = "RDS security group description"
  type        = string
}

variable "ec2_key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "bastion_ami_id" {
  description = "Bastion AMI ID"
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion instance type"
  type        = string
}

variable "app_ami_id" {
  description = "Application server AMI ID"
  type        = string
}

variable "app_instance_type" {
  description = "Application server instance type"
  type        = string
}

variable "rds_identifier" {
  description = "RDS instance identifier"
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
  description = "RDS allocated storage"
  type        = number
}

variable "rds_multi_az" {
  description = "Whether RDS is Multi-AZ"
  type        = bool
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention period"
  type        = number
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip the final snapshot"
  type        = bool
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN used by EKS control plane"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN used by EKS managed node group"
  type        = string
}

variable "eks_node_group_name" {
  description = "EKS node group name"
  type        = string
}

variable "eks_node_instance_types" {
  description = "EKS node instance types"
  type        = list(string)
}

variable "eks_node_capacity_type" {
  description = "EKS node capacity type"
  type        = string
}

variable "eks_node_ami_type" {
  description = "EKS node AMI type"
  type        = string
}

variable "eks_node_version" {
  description = "EKS node Kubernetes version"
  type        = string
}

variable "eks_node_desired_size" {
  description = "Desired EKS node count"
  type        = number
}

variable "eks_node_min_size" {
  description = "Minimum EKS node count"
  type        = number
}

variable "eks_node_max_size" {
  description = "Maximum EKS node count"
  type        = number
}

variable "eks_node_subnet_keys" {
  description = "Private application subnet keys used by EKS nodes"
  type        = list(string)
}

variable "rds_kms_key_id" {
  description = "KMS key ARN used by the existing RDS instance"
  type        = string
}

variable "rds_security_group_ids" {
  description = "Existing security groups attached to the RDS instance"
  type        = list(string)
}

variable "legacy_app_security_group_id" {
  description = "Existing additional security group attached to the application server"
  type        = string
}

variable "eks_cluster_security_group_id" {
  description = "Existing EKS control-plane security group"
  type        = string
}

variable "eks_node_launch_template_id" {
  description = "Existing EKS managed node group launch template ID"
  type        = string
}

variable "eks_node_launch_template_version" {
  description = "Existing EKS managed node group launch template version"
  type        = string
}

variable "vpc_cni_role_arn" {
  description = "Existing IAM role used by the VPC CNI addon"
  type        = string
}

variable "eks_cluster_tags" {
  description = "Existing EKS cluster tags"
  type        = map(string)
}

variable "eks_node_labels" {
  description = "Existing EKS node labels"
  type        = map(string)
}

variable "eks_node_tags" {
  description = "Existing EKS node group tags"
  type        = map(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
