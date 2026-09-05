module "iam" {
  source = "./modules/iam"

  role_name             = "${var.project_name}-devops-role"
  role_description      = "Allows EC2 instances to call AWS services on your behalf."
  policy_name           = "AmmaPickles-DevOps-Access"
  instance_profile_name = "${var.project_name}-devops-role"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid      = "ECRAccess"
        Effect   = "Allow"
        Action   = ["ecr:*"]
        Resource = "*"
      },
      {
        Sid      = "EKSAccess"
        Effect   = "Allow"
        Action   = ["eks:*"]
        Resource = "*"
      },
      {
        Sid    = "IAMAccess"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:ListRoles",
          "iam:UpdateRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:GetInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:PassRole",
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider",
          "iam:ListOpenIDConnectProviders",
          "iam:TagRole",
          "iam:TagInstanceProfile",
          "iam:TagOpenIDConnectProvider"
        ]
        Resource = "*"
      },
      {
        Sid      = "RDSAccess"
        Effect   = "Allow"
        Action   = ["rds:*"]
        Resource = "*"
      },
      {
        Sid      = "CloudFormationAccess"
        Effect   = "Allow"
        Action   = ["cloudformation:*"]
        Resource = "*"
      },
      {
        Sid      = "EC2Access"
        Effect   = "Allow"
        Action   = ["ec2:*"]
        Resource = "*"
      },
      {
        Sid      = "CloudWatchAccess"
        Effect   = "Allow"
        Action   = ["cloudwatch:*"]
        Resource = "*"
      },
      {
        Sid      = "CloudWatchLogsAccess"
        Effect   = "Allow"
        Action   = ["logs:*"]
        Resource = "*"
      },
      {
        Sid      = "SecretsManagerAccess"
        Effect   = "Allow"
        Action   = ["secretsmanager:*"]
        Resource = "*"
      },
      {
        Sid      = "SSMAccess"
        Effect   = "Allow"
        Action   = ["ssm:*"]
        Resource = "*"
      },
      {
        Sid      = "STSAccess"
        Effect   = "Allow"
        Action   = ["sts:GetCallerIdentity"]
        Resource = "*"
      },
      {
        Sid    = "TerraformStateBucket"
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock"
        ]
        Resource = "arn:aws:s3:::amma-pickles-terraform-state-597994428626"
      },
      {
        Sid    = "TerraformStateObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::amma-pickles-terraform-state-597994428626/*"
      },
      {
        Sid    = "TerraformStateKMS"
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "arn:aws:kms:ap-northeast-1:597994428626:key/8c624857-7943-40eb-baba-ae9682e1ad4a"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-devops-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

moved {
  from = aws_iam_role.devops
  to   = module.iam.aws_iam_role.devops
}

moved {
  from = aws_iam_role_policy.devops
  to   = module.iam.aws_iam_role_policy.devops
}

moved {
  from = aws_iam_instance_profile.devops
  to   = module.iam.aws_iam_instance_profile.devops
}
