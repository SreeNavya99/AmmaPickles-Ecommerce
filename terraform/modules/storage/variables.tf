variable "availability_zone" {
  description = "Availability Zone where the EBS volume will exist"
  type        = string
}

variable "size" {
  description = "EBS volume size in GB"
  type        = number
}

variable "volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp3"
}

variable "name" {
  description = "Name tag for the EBS volume"
  type        = string
}
