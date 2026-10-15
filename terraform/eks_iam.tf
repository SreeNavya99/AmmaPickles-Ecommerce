# ============================================================
# EKS Cluster IAM Role
# ============================================================

resource "aws_iam_role" "eks_cluster" {
  name        = "${var.project_name}-eks-cluster-role"
  description = "IAM role used by the Amazon EKS control plane"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-eks-cluster-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}


# ============================================================
# EKS Cluster IAM Policy Attachment
# ============================================================

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# ============================================================
# EKS Worker Node IAM Role
# ============================================================

resource "aws_iam_role" "eks_node" {
  name        = "${var.project_name}-eks-node-role"
  description = "IAM role used by Amazon EKS worker nodes"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-eks-node-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}


# ============================================================
# EKS Worker Node Policy
# ============================================================

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


# ============================================================
# ECR Pull Permission
# ============================================================

resource "aws_iam_role_policy_attachment" "eks_ecr_pull_policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}


# ============================================================
# VPC CNI Permission
# ============================================================

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
# ============================================================
# EKS IAM Outputs
# ============================================================

output "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN used by the EKS managed node group"
  value       = aws_iam_role.eks_node.arn
}
