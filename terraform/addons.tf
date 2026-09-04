resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = aws_eks_cluster.amma_pickles.name
  addon_name               = "vpc-cni"
  addon_version            = "v1.22.4-eksbuild.3"
  service_account_role_arn = "arn:aws:iam::597994428626:role/amma-pickles-vpc-cni-role"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.amma_pickles.name
  addon_name    = "coredns"
  addon_version = "v1.12.4-eksbuild.29"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.amma_pickles.name
  addon_name    = "kube-proxy"
  addon_version = "v1.34.6-eksbuild.21"

  lifecycle {
    prevent_destroy = true
  }
}
