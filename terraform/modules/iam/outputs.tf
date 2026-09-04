output "role_name" {
  value = aws_iam_role.devops.name
}

output "role_arn" {
  value = aws_iam_role.devops.arn
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.devops.name
}
