module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id

  bastion_name        = "amma-pickles-bastion-sg"
  bastion_description = "sg for bh"
  bastion_ssh_cidr    = var.bastion_ssh_cidr

  app_name        = "amma-pickles-app-sg"
  app_description = "sg for as"

  alb_name        = "amma-pickles-alb-sg"
  alb_description = "sg for alb"

  rds_name        = "amma-pickles-rds-sg"
  rds_description = "sg for rds"


  eks_cluster_name        = "amma-pickles-eks-cluster-sg"
  eks_cluster_description = "Security group for Amma Pickles EKS cluster"

}

moved {
  from = aws_security_group.bastion
  to   = module.security.aws_security_group.bastion
}

moved {
  from = aws_security_group.app
  to   = module.security.aws_security_group.app
}

moved {
  from = aws_security_group.alb
  to   = module.security.aws_security_group.alb
}

moved {
  from = aws_security_group.rds
  to   = module.security.aws_security_group.rds
}

resource "aws_security_group_rule" "rds_from_eks" {
  description              = "MySQLFromEKS"
  type                     = "ingress"
  security_group_id        = module.security.rds_security_group_id
  source_security_group_id = module.eks.cluster_security_group_id
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
}

resource "aws_security_group_rule" "rds_from_app" {
  description              = "MySQLFromApp"
  type                     = "ingress"
  security_group_id        = module.security.rds_security_group_id
  source_security_group_id = module.security.app_security_group_id
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
}

