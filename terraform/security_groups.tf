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
