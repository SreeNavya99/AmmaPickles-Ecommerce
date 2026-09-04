resource "aws_eks_cluster" "amma_pickles" {
  name     = var.eks_cluster_name
  version  = var.eks_kubernetes_version
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_app["app_a"].id,
      aws_subnet.private_app["app_c"].id
    ]

    endpoint_private_access = false
    endpoint_public_access  = true

    public_access_cidrs = [
      "0.0.0.0/0"
    ]

    security_group_ids = [
      "sg-087feae7d0b219c74"
    ]
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name                                          = "eksctl-amma-pickles-eks-cluster/ControlPlane"
    "alpha.eksctl.io/cluster-name"                = "amma-pickles-eks"
    "alpha.eksctl.io/cluster-oidc-enabled"        = "true"
    "alpha.eksctl.io/eksctl-version"              = "0.230.0"
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = "amma-pickles-eks"
  }
}

resource "aws_eks_node_group" "amma_pickles" {
  cluster_name    = aws_eks_cluster.amma_pickles.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_role_arn

  subnet_ids = [
    aws_subnet.private_app["app_a"].id,
    aws_subnet.private_app["app_c"].id
  ]

  instance_types = var.eks_node_instance_types

  scaling_config {
    desired_size = var.eks_node_desired_size
    min_size     = var.eks_node_min_size
    max_size     = var.eks_node_max_size
  }

  labels = {
    "alpha.eksctl.io/cluster-name"   = "amma-pickles-eks"
    "alpha.eksctl.io/nodegroup-name" = "amma-pickles-ng"
  }

  launch_template {
    id      = "lt-0bb33be927e423888"
    version = "1"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    "alpha.eksctl.io/cluster-name"                = "amma-pickles-eks"
    "alpha.eksctl.io/eksctl-version"              = "0.230.0"
    "alpha.eksctl.io/nodegroup-name"              = "amma-pickles-ng"
    "alpha.eksctl.io/nodegroup-type"              = "managed"
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = "amma-pickles-eks"
  }
}
