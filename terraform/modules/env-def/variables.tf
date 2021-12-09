variable "prefix" {}
variable "env" {}
variable "region" {}
variable "vpc_cidr_block" {}
variable "private_subnet_count" {}
variable "availability_zones" {}
variable "admin_workstation_ip" {}
variable "bastion_instance_type" {}
variable "ssh_key_path" {}
variable "list_public_subnets" {
  type    = list(string)
}

variable "list_private_subnets" {
  type    = list(string)
}

variable "list_database_subnets" {
  type    = list(string)
}

# ----- FARGATE ECS -----------
variable "ecs_service_desired_count" {}
# core 
variable "ecr_url_core_repo" {}
variable "ecr_image_core_tag" {}
variable "avb_core_port" {}
# actions
variable "ecr_url_actions_repo" {}
variable "ecr_image_actions_tag" {}
variable "avb_actions_port" {}
variable "ephemeral_storage" {}
#duckling
variable "ecr_url_duckling_repo" {}
variable "ecr_image_duckling_tag" {}
variable "avb_duckling_port" {}

variable "fargate_container_memory" {}
variable "fargate_container_cpu" {}

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
# buckets publicos
variable "bucket_list" {}
# buckets privados
variable "bucket_private_list" {}
# route53
variable "private_zone_name" {}

# Private api
variable "domain_name" {}
variable "prefix_core_dns" {}
variable "public_zone_id" {}
variable "prefix_dns" {}
variable "certificado_arn" {}
variable "id_apigateway" {}
variable "ip-endpoint1" {}
variable "ip-endpoint2" {}

# Cloudfront
variable "prefix_alias" {}
variable "path_index_file" {}
variable "cdn_bucket_name" {}
variable "git_url_repo" {}
variable "temporal_path" {}
variable "repo_folder_index" {}