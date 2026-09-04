resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = [var.bastion_security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = var.bastion_name
  }
}

resource "aws_instance" "app_server" {
  ami                    = var.app_ami_id
  instance_type          = var.app_instance_type
  subnet_id              = var.app_subnet_id
  key_name               = var.ec2_key_name

  vpc_security_group_ids = [
    var.app_security_group_id,
    var.legacy_app_security_group_id
  ]

  iam_instance_profile = var.instance_profile_name

  tags = {
    Name = var.app_server_name
  }
}
