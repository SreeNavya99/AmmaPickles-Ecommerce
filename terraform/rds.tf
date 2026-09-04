resource "aws_db_subnet_group" "amma_pickles" {
  name        = "amma-pickles-db-subnet-group"
  description = "db subnet group"

  subnet_ids = [
    aws_subnet.private_db["db_a"].id,
    aws_subnet.private_db["db_c"].id
  ]
}

resource "aws_db_instance" "amma_pickles" {
  identifier = var.rds_identifier

  engine         = var.rds_engine
  engine_version = var.rds_engine_version

  instance_class = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = 1000
  storage_type          = "gp2"
  storage_encrypted     = true

  kms_key_id = "arn:aws:kms:ap-northeast-1:597994428626:key/57c0a679-2a30-401e-b1e7-9571f7147fd2"

  db_subnet_group_name = aws_db_subnet_group.amma_pickles.name

  vpc_security_group_ids = [
    "sg-0c6128221c87d0195",
    "sg-0dfd77f953bb63f03",
    "sg-0ee802f81c7c8fe4c"
  ]

  publicly_accessible = false
  multi_az            = var.rds_multi_az

  backup_retention_period = var.rds_backup_retention_period
  copy_tags_to_snapshot   = true

  skip_final_snapshot = var.rds_skip_final_snapshot
  deletion_protection = false

  lifecycle {
    prevent_destroy = true
  }
}
