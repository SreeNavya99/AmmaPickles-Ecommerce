variable "role_name" {
  type = string
}

variable "role_description" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "policy" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
