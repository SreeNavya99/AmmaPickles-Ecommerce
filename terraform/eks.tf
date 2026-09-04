module "eks" {
  source = "./modules/eks"

  cluster_name       = var.eks_cluster_name
  kubernetes_version = var.eks_kubernetes_version
  cluster_role_arn   = var.eks_cluster_role_arn

  subnet_ids = [
    module.network.private_app_subnet_ids["app_a"],
    module.network.private_app_subnet_ids["app_c"]
  ]

  cluster_security_group_id = var.eks_cluster_security_group_id
  cluster_tags              = var.eks_cluster_tags

  node_group_name     = var.eks_node_group_name
  node_role_arn       = var.eks_node_role_arn
  node_instance_types = var.eks_node_instance_types
  node_desired_size   = var.eks_node_desired_size
  node_min_size       = var.eks_node_min_size
  node_max_size       = var.eks_node_max_size

  node_labels = var.eks_node_labels

  launch_template_id      = var.eks_node_launch_template_id
  launch_template_version = var.eks_node_launch_template_version

  node_tags = var.eks_node_tags
}

moved {
  from = aws_eks_cluster.amma_pickles
  to   = module.eks.aws_eks_cluster.amma_pickles
}

moved {
  from = aws_eks_node_group.amma_pickles
  to   = module.eks.aws_eks_node_group.amma_pickles
}
