
resource "aws_security_group" "eks_cluster" {
  name        = var.eks_cluster_name
  description = var.eks_cluster_description
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTPS from application and Jenkins instances"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }
  ingress {
    description = "Allow communication within EKS security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks_cluster_name
  }
}

