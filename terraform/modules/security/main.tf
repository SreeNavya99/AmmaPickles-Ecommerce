resource "aws_security_group" "bastion" {
  name        = var.bastion_name
  description = var.bastion_description
  vpc_id      = var.vpc_id

  ingress {
    description = ""
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.bastion_ssh_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = var.app_name
  description = var.app_description
  vpc_id      = var.vpc_id

  ingress {
    description     = "appserver"
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "jenkins"
    protocol        = "tcp"
    from_port       = 8082
    to_port         = 8082
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "nexus"
    protocol        = "tcp"
    from_port       = 8081
    to_port         = 8081
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name        = var.alb_name
  description = var.alb_description
  vpc_id      = var.vpc_id

  ingress {
    description = ""
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = ""
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  name        = var.rds_name
  description = var.rds_description
  vpc_id      = var.vpc_id

  ingress {
    description     = "rds to appserver"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.app.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
