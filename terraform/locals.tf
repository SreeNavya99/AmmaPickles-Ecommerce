locals {
  name_prefix = var.project_name

  public_subnets = {
    public_a = {
      cidr = var.public_subnet_cidrs[0]
      az   = var.availability_zones[0]
      name = "amma-pickles-public-subnet-az1"
    }

    public_c = {
      cidr = var.public_subnet_cidrs[1]
      az   = var.availability_zones[1]
      name = "amma-pickles-public-subnet-az2"
    }
  }

  private_app_subnets = {
    app_a = {
      cidr = var.private_app_subnet_cidrs[0]
      az   = var.availability_zones[0]
      name = "amma-pickles-private-app-subnet-az1"
    }

    app_c = {
      cidr = var.private_app_subnet_cidrs[1]
      az   = var.availability_zones[1]
      name = "amma-pickles-private-app-subnet-az2"
    }
  }

  private_db_subnets = {
    db_a = {
      cidr = var.private_db_subnet_cidrs[0]
      az   = var.availability_zones[0]
      name = "amma-pickles-private-db-subnet-az1"
    }

    db_c = {
      cidr = var.private_db_subnet_cidrs[1]
      az   = var.availability_zones[1]
      name = "amma-pickles-private-db-subnet-az2"
    }
  }
}
