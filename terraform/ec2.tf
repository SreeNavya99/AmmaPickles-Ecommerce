module "compute" {
  source = "./modules/compute"

  bastion_ami_id            = var.bastion_ami_id
  bastion_instance_type     = var.bastion_instance_type
  public_subnet_id          = module.network.public_subnet_ids["public_a"]
  ec2_key_name              = var.ec2_key_name
  bastion_security_group_id = module.security.bastion_security_group_id
  bastion_name              = "amma-pickles-bastion"

  app_ami_id            = var.app_ami_id
  app_instance_type     = var.app_instance_type
  app_subnet_id         = module.network.private_app_subnet_ids["app_a"]
  app_security_group_id = module.security.app_security_group_id

  instance_profile_name = module.iam.instance_profile_name
  app_server_name       = "amma-pickles-app-server"
}
