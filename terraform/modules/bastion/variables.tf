variable "prefix" {}
variable "env" {}
variable "region" {}
variable "vpc_id" {}

variable "public_subnet_id" {}
variable "public_subnet_sg" {}

variable "bastion_instance_type" {}
variable "ssh_key_path" {}
variable "generate_ssh_key" {}

# RDS utils
variable "pg_username" {}
variable "pg_password" {}
variable "pg_endpoint" {}

#TODO: ESTA VARIABLE YA NO VA!!!!
variable "pg_db_core" {
  default = "db_rasa_broker"
}

# scripts rds
variable "bucket_temp" {}