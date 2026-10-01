resource "aws_ebs_volume" "app_data" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.volume_type

  tags = {
    Name = var.name
  }
}
