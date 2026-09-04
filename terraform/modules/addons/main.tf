resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  addon_version            = var.vpc_cni_version
  service_account_role_arn = var.vpc_cni_role_arn

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = var.cluster_name
  addon_name    = "coredns"
  addon_version = var.coredns_version

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = var.cluster_name
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version

  lifecycle {
    prevent_destroy = true
  }
}
