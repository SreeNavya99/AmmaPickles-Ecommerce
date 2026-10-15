output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
output "eks_cluster_security_group_id" {
  description = "Security group ID for the EKS cluster"
  value       = aws_security_group.eks_cluster.id
}

