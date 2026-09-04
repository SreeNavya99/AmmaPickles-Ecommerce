output "cluster_name" {
  value = aws_eks_cluster.amma_pickles.name
}

output "cluster_arn" {
  value = aws_eks_cluster.amma_pickles.arn
}

output "node_group_name" {
  value = aws_eks_node_group.amma_pickles.node_group_name
}
