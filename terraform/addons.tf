module "addons" {
  source = "./modules/addons"

  cluster_name       = module.eks.cluster_name
  vpc_cni_version    = "v1.22.4-eksbuild.3"
  vpc_cni_role_arn   = var.vpc_cni_role_arn
  coredns_version    = "v1.12.4-eksbuild.29"
  kube_proxy_version = "v1.34.6-eksbuild.21"
}

moved {
  from = aws_eks_addon.vpc_cni
  to   = module.addons.aws_eks_addon.vpc_cni
}

moved {
  from = aws_eks_addon.coredns
  to   = module.addons.aws_eks_addon.coredns
}

moved {
  from = aws_eks_addon.kube_proxy
  to   = module.addons.aws_eks_addon.kube_proxy
}
