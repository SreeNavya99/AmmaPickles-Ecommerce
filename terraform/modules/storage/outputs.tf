output "volume_id" {
  description = "ID of the EBS volume"
  value       = aws_ebs_volume.app_data.id
}

output "volume_arn" {
  description = "ARN of the EBS volume"
  value       = aws_ebs_volume.app_data.arn
}

output "volume_size" {
  description = "Size of the EBS volume"
  value       = aws_ebs_volume.app_data.size
}

