output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value       = module.network.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.network.private_db_subnet_ids
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = module.security.bastion_security_group_id
}

output "app_security_group_id" {
  description = "Application security group ID"
  value       = module.security.app_security_group_id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = module.security.alb_security_group_id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = module.security.rds_security_group_id
}

output "bastion_instance_id" {
  description = "Bastion instance ID"
  value       = module.compute.bastion_instance_id
}

output "app_server_instance_id" {
  description = "Application server instance ID"
  value       = module.compute.app_server_instance_id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_node_group_name" {
  description = "EKS node group name"
  value       = module.eks.node_group_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.database.endpoint
}

output "devops_role_arn" {
  description = "DevOps IAM role ARN"
  value       = module.iam.role_arn
}

output "devops_instance_profile_name" {
  description = "DevOps EC2 instance profile name"
  value       = module.iam.instance_profile_name
}
