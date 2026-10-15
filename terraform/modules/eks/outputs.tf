output "cluster_name" {
  value = aws_eks_cluster.amma_pickles.name
}

output "cluster_arn" {
  value = aws_eks_cluster.amma_pickles.arn
}

output "node_group_name" {
  value = aws_eks_node_group.amma_pickles.node_group_name
}
output "cluster_security_group_id" {
  description = "AWS-managed EKS cluster security group ID"
  value       = aws_eks_cluster.amma_pickles.vpc_config[0].cluster_security_group_id
}

