resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public["public_a"].id
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "amma-pickles-bastion"
  }
}

resource "aws_instance" "app_server" {
  ami           = var.app_ami_id
  instance_type = var.app_instance_type
  subnet_id     = aws_subnet.private_app["app_a"].id
  key_name      = var.ec2_key_name

  vpc_security_group_ids = [
    aws_security_group.app.id,
    "sg-0c17ffa839fb3c338"
  ]

  iam_instance_profile = aws_iam_instance_profile.devops.name

  tags = {
    Name = "amma-pickles-app-server"
  }
}
