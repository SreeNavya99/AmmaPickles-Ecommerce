output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "app_server_instance_id" {
  value = aws_instance.app_server.id
}
