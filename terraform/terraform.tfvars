project_name = "amma-pickles"
aws_region   = "ap-northeast-1"
environment  = "dev"

vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c"
]

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

nat_eip_count = 1

bastion_ssh_cidr = "43.207.227.172/32"

bastion_ami_id        = "ami-06380d26ad7176f2c"
bastion_instance_type = "t3.micro"

app_ami_id        = "ami-06380d26ad7176f2c"
app_instance_type = "t3.micro"

ec2_key_name = "keypair"
