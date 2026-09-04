variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
    name = string
  }))
}

variable "private_app_subnets" {
  type = map(object({
    cidr = string
    az   = string
    name = string
  }))
}

variable "private_db_subnets" {
  type = map(object({
    cidr = string
    az   = string
    name = string
  }))
}

variable "igw_name" {
  type = string
}

variable "nat_eip_count" {
  type = number
}

variable "nat_gateway_id" {
  type = string
}

variable "public_route_table_name" {
  type = string
}

variable "private_app_route_table_name" {
  type = string
}

variable "private_db_route_table_name" {
  type = string
}
