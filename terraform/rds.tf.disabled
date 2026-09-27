module "database" {
  source = "./modules/database"

  db_subnet_group_name        = "amma-pickles-db-subnet-group"
  db_subnet_group_description = "db subnet group"

  db_subnet_ids = [
    module.network.private_db_subnet_ids["db_a"],
    module.network.private_db_subnet_ids["db_c"]
  ]

  identifier = var.rds_identifier

  engine         = var.rds_engine
  engine_version = var.rds_engine_version

  instance_class = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = 1000
  storage_type          = "gp2"

  kms_key_id = var.rds_kms_key_id

  vpc_security_group_ids = var.rds_security_group_ids

  multi_az                = var.rds_multi_az
  backup_retention_period = var.rds_backup_retention_period
  skip_final_snapshot     = var.rds_skip_final_snapshot
}

moved {
  from = aws_db_subnet_group.amma_pickles
  to   = module.database.aws_db_subnet_group.amma_pickles
}

moved {
  from = aws_db_instance.amma_pickles
  to   = module.database.aws_db_instance.amma_pickles
}
