output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "app_server_instance_id" {
  value = aws_instance.app_server.id
}

output "nexus_server_instance_id" {
  description = "Instance ID of the Nexus server"
  value       = aws_instance.nexus_server.id
}
