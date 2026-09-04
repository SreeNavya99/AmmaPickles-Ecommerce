output "db_subnet_group_name" {
  value = aws_db_subnet_group.amma_pickles.name
}

output "db_instance_id" {
  value = aws_db_instance.amma_pickles.id
}

output "endpoint" {
  value = aws_db_instance.amma_pickles.endpoint
}
