resource "aws_security_group" "eks_cluster" {
  name        = var.eks_cluster_name
  description = var.eks_cluster_description
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks_cluster_name
  }
}
