# Local variables for the module
# Do not override here! Override in a .auto.tfvars file in the root of the project

variable "instance_profile" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "init_commands" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "debug" {
  type = bool
}
