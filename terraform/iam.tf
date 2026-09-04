resource "aws_iam_role" "devops" {
  name = "${var.project_name}-devops-role"

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

  description = "Allows EC2 instances to call AWS services on your behalf."

  tags = {
    Name        = "${var.project_name}-devops-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy" "devops" {
  name = "AmmaPickles-DevOps-Access"
  role = aws_iam_role.devops.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid      = "ECR"
        Effect   = "Allow"
        Action   = ["ecr:*"]
        Resource = "*"
      },
      {
        Sid      = "EKS"
        Effect   = "Allow"
        Action   = ["eks:*"]
        Resource = "*"
      },
      {
        Sid    = "IAM"
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetInstanceProfile",
          "iam:ListInstanceProfilesForRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateRole",
          "iam:UpdateRoleDescription",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:PassRole",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:CreateServiceLinkedRole",
          "iam:GetOpenIDConnectProvider",
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:TagRole",
          "iam:TagInstanceProfile",
          "iam:UntagRole",
          "iam:UntagInstanceProfile"
        ]
        Resource = "*"
      },
      {
        Sid      = "RDS"
        Effect   = "Allow"
        Action   = ["rds:*"]
        Resource = "*"
      },
      {
        Sid      = "CloudFormation"
        Effect   = "Allow"
        Action   = ["cloudformation:*"]
        Resource = "*"
      },
      {
        Sid      = "EC2"
        Effect   = "Allow"
        Action   = ["ec2:*"]
        Resource = "*"
      },
      {
        Sid      = "CloudWatch"
        Effect   = "Allow"
        Action   = ["cloudwatch:*"]
        Resource = "*"
      },
      {
        Sid      = "Logs"
        Effect   = "Allow"
        Action   = ["logs:*"]
        Resource = "*"
      },
      {
        Sid      = "SecretsManager"
        Effect   = "Allow"
        Action   = ["secretsmanager:*"]
        Resource = "*"
      },
      {
        Sid      = "SSM"
        Effect   = "Allow"
        Action   = ["ssm:*"]
        Resource = "*"
      },
      {
        Sid      = "STS"
        Effect   = "Allow"
        Action   = ["sts:GetCallerIdentity"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "devops" {
  name = "${var.project_name}-devops-role"
  role = aws_iam_role.devops.name
}
