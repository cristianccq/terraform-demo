variable "prefix" {}
variable "env" {}
variable "region" {}
variable "vpc_cidr_block" {}
variable "private_subnet_count" {}
variable "admin_workstation_ip" {}
variable "availability_zones" {}
variable "list_database_subnets" {
  type    = list(string)
}

# outputs from vpc
variable "vpc_id" {}

# ------- RDS --------
variable "identifier" {}

variable "name" {}
variable "username" {}
variable "password" {}
variable "port_db" {}
variable "multi_az" {}

variable "engine" {}
variable "engine_version" {}
variable "family" {}
variable "major_engine_version" {}
variable "instance_class" {}

variable "allocated_storage" {}
variable "max_allocated_storage" {}
variable "storage_encrypted" {}

variable "publicly_accessible" {}

variable "backup_retention_period" {}
variable "skip_final_snapshot" {}
variable "deletion_protection" {}

variable "backup_window" {}
variable "maintenance_window" {}

# para el script en el bucket
variable "bucket_temp" {}