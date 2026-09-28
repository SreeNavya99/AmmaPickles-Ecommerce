resource "aws_ecr_repository" "services" {
  for_each = var.container_services

  name                 = "${var.project_name}/${each.value}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Service     = each.value
    ManagedBy   = "Terraform"
  }
}
