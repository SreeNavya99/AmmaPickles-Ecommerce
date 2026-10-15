module "addons" {
  source = "./modules/addons"

  cluster_name       = module.eks.cluster_name
  kubernetes_version = "1.36"
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
