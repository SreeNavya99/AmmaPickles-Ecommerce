variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_security_group_id" {
  type = string
}

variable "cluster_tags" {
  type = map(string)
}

variable "node_group_name" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_desired_size" {
  type = number
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "node_labels" {
  type = map(string)
}

variable "node_tags" {
  type = map(string)
}
variable "bastion_ssh_cidr" {
  description = "Trusted public IP range for EKS API access"
  type        = list(string)
}
