variable "db_subnet_group_name" {
  type = string
}

variable "db_subnet_group_description" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "multi_az" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}

variable "skip_final_snapshot" {
  type = bool
}
