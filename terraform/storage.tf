module "storage" {
  source = "./modules/storage"

  availability_zone = var.storage_availability_zone
  size              = var.storage_size
  volume_type       = var.storage_volume_type
  name              = var.storage_name
}
