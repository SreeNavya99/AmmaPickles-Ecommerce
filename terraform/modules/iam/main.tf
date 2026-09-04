resource "aws_iam_role" "devops" {
  name = var.role_name

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

  description = var.role_description

  tags = var.tags
}

resource "aws_iam_role_policy" "devops" {
  name = var.policy_name
  role = aws_iam_role.devops.id

  policy = var.policy
}

resource "aws_iam_instance_profile" "devops" {
  name = var.instance_profile_name
  role = aws_iam_role.devops.name
}
