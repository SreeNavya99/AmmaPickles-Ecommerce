resource "aws_security_group" "bastion" {
  name        = "amma-pickles-bastion-sg"
  description = "sg for bh"
  vpc_id      = aws_vpc.amma_pickles.id

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
  name        = "amma-pickles-app-sg"
  description = "sg for as"
  vpc_id      = aws_vpc.amma_pickles.id

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
  name        = "amma-pickles-alb-sg"
  description = "sg for alb"
  vpc_id      = aws_vpc.amma_pickles.id

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
  name        = "amma-pickles-rds-sg"
  description = "sg for rds"
  vpc_id      = aws_vpc.amma_pickles.id

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
