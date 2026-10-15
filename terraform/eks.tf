module "eks" {
  source = "./modules/eks"

  cluster_name              = "${var.project_name}-eks"
  kubernetes_version        = "1.36"
  cluster_role_arn          = aws_iam_role.eks_cluster.arn
  subnet_ids                = values(module.network.private_app_subnet_ids)
  cluster_security_group_id = module.security.eks_cluster_security_group_id
  bastion_ssh_cidr          = var.bastion_ssh_cidr

  cluster_tags = {
    Name        = "${var.project_name}-eks"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }

  node_group_name     = "${var.project_name}-nodes"
  node_role_arn       = aws_iam_role.eks_node.arn
  node_instance_types = ["t3.small"]

  node_desired_size = 1
  node_min_size     = 1
  node_max_size     = 2

  node_labels = {
    workload = "general"
  }

  node_tags = {
    Name        = "${var.project_name}-eks-worker"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}
