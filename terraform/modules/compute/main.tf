resource "aws_instance" "bastion" {
  ami           = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  subnet_id     = var.public_subnet_id

  key_name = var.ec2_key_name

  vpc_security_group_ids = [
    var.bastion_security_group_id
  ]

  iam_instance_profile = var.instance_profile_name

  tags = {
    Name = var.bastion_name
  }
}


resource "aws_instance" "app_server" {
  ami           = var.app_ami_id
  instance_type = var.app_instance_type
  subnet_id     = var.app_subnet_id

  vpc_security_group_ids = [
    var.app_security_group_id
  ]

  iam_instance_profile = var.instance_profile_name

  user_data = <<-EOF_USERDATA
    #!/bin/bash

    set -euxo pipefail

    dnf update -y

    dnf install -y \
      git \
      docker \
      java-21-amazon-corretto

    systemctl enable docker
    systemctl start docker

    usermod -aG docker ec2-user

    mkdir -p /home/ec2-user/.ssh
    chmod 700 /home/ec2-user/.ssh
    chown -R ec2-user:ec2-user /home/ec2-user/.ssh

    echo "CI/App server bootstrap completed."
  EOF_USERDATA

  tags = {
    Name = var.app_server_name
  }
}


