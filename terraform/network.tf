module "network" {
  source = "./modules/network"

  vpc_cidr                     = var.vpc_cidr
  vpc_name                     = "${local.name_prefix}-vpc"
  public_subnets               = local.public_subnets
  private_app_subnets          = local.private_app_subnets
  private_db_subnets           = local.private_db_subnets
  igw_name                     = "${local.name_prefix}-igw"
  nat_eip_count                = var.nat_eip_count
  nat_gateway_id               = var.nat_gateway_id
  public_route_table_name      = "${local.name_prefix}-public-rt"
  private_app_route_table_name = "${local.name_prefix}-private-rt"
  private_db_route_table_name  = "${local.name_prefix}-db-rt"
}

moved {
  from = aws_vpc.amma_pickles
  to   = module.network.aws_vpc.amma_pickles
}

moved {
  from = aws_subnet.public
  to   = module.network.aws_subnet.public
}

moved {
  from = aws_subnet.private_app
  to   = module.network.aws_subnet.private_app
}

moved {
  from = aws_subnet.private_db
  to   = module.network.aws_subnet.private_db
}

moved {
  from = aws_internet_gateway.amma_pickles
  to   = module.network.aws_internet_gateway.amma_pickles
}

moved {
  from = aws_eip.nat
  to   = module.network.aws_eip.nat
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table.private_app
  to   = module.network.aws_route_table.private_app
}

moved {
  from = aws_route_table.private_db
  to   = module.network.aws_route_table.private_db
}

moved {
  from = aws_route_table_association.public
  to   = module.network.aws_route_table_association.public
}

moved {
  from = aws_route_table_association.private_app
  to   = module.network.aws_route_table_association.private_app
}

moved {
  from = aws_route_table_association.private_db
  to   = module.network.aws_route_table_association.private_db
}
