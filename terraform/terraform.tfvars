aws_region = "ap-northeast-1"

project_name = "amma-pickles"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_app_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

private_db_subnet_cidrs = [
  "10.0.21.0/24",
  "10.0.22.0/24"
]

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c"
]

nat_eip_count = 1

bastion_ami_id        = "ami-06380d26ad7176f2c"
bastion_instance_type = "t3.micro"
ec2_key_name          = "keypair"
bastion_ssh_cidr      = "49.43.234.35/32"

app_ami_id        = "ami-06380d26ad7176f2c"
app_instance_type = "c7i-flex.large"

rds_identifier = "amma-pickles-db"

rds_engine         = "mysql"
rds_engine_version = "8.4.11"

rds_instance_class = "db.t4g.micro"

rds_allocated_storage     = 20
rds_max_allocated_storage = 1000
rds_storage_type          = "gp3"

rds_multi_az                = false
rds_backup_retention_period = 1
rds_skip_final_snapshot     = true

rds_username = "ammaadmin"

environment = "dev"


container_services = [
  "auth-service",
  "user-service",
  "address-service",
  "category-service",
  "product-service",
  "cart-service",
  "order-service",
  "notification-service"
]
