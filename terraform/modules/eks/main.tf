resource "aws_eks_cluster" "amma_pickles" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids

    endpoint_private_access = false
    endpoint_public_access  = true

    public_access_cidrs = [
      "0.0.0.0/0"
    ]

    security_group_ids = [
      var.cluster_security_group_id
    ]
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.cluster_tags
}

resource "aws_eks_node_group" "amma_pickles" {
  cluster_name    = aws_eks_cluster.amma_pickles.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn

  subnet_ids = var.subnet_ids

  instance_types = var.node_instance_types

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  labels = var.node_labels

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.node_tags
}
