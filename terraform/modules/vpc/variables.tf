variable "prefix" {}
variable "env" {}
variable "region" {}
variable "vpc_cidr_block" {}
variable "azs" {}
variable "private_subnet_count" {}
variable "avb_core_port" {}
variable "avb_actions_port" {}
variable "avb_duckling_port" {}
variable "admin_workstation_ip" {}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = []
}
