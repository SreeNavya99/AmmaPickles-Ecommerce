output "vpc_id" {
  description = "Amma Pickles VPC ID"
  value       = aws_vpc.amma_pickles.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = { for k, v in aws_subnet.public : k => v.id }
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value       = { for k, v in aws_subnet.private_app : k => v.id }
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = { for k, v in aws_subnet.private_db : k => v.id }
}

output "bastion_instance_id" {
  description = "Bastion EC2 instance ID"
  value       = aws_instance.bastion.id
}

output "app_server_instance_id" {
  description = "DevOps/application EC2 instance ID"
  value       = aws_instance.app_server.id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.amma_pickles.name
}

output "eks_node_group_name" {
  description = "EKS node group name"
  value       = aws_eks_node_group.amma_pickles.node_group_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.amma_pickles.endpoint
}
