resource "aws_db_subnet_group" "amma_pickles" {
  name        = var.db_subnet_group_name
  description = var.db_subnet_group_description

  subnet_ids = var.db_subnet_ids
}

resource "aws_db_instance" "amma_pickles" {
  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = true

  kms_key_id = var.kms_key_id

  db_subnet_group_name = aws_db_subnet_group.amma_pickles.name

  vpc_security_group_ids = var.vpc_security_group_ids

  publicly_accessible = false
  multi_az            = var.multi_az

  backup_retention_period = var.backup_retention_period
  copy_tags_to_snapshot   = true

  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = false

  lifecycle {
    prevent_destroy = true
  }
}
