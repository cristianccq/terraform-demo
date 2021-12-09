variable "prefix" {}
variable "env" {}
variable "region" {}
variable "ecs_service_desired_count" {}
variable "ecs_private_subnet_az_names" {}
variable "ecs_private_subnet_ids" {
  type        = list(string)
  default     = []
}
variable "alb_public_subnet_ids" {
  type        = list(string)
  default     = []
}

variable "fargate_container_memory" {}
variable "fargate_container_cpu" {}


#core
variable "ecr_image_core_url" {}
variable "ecr_image_core_tag" {}
variable "avb_core_port" {}
variable "ephemeral_storage" {}
#actions
variable "ecr_image_actions_url" {}
variable "ecr_image_actions_tag" {}
variable "avb_actions_port" {}
#duckling
variable "ecr_image_duckling_url" {}
variable "ecr_image_duckling_tag" {}
variable "avb_duckling_port" {}


variable "vpc_id" {}
variable "aws_account_id" {}


variable "admin_workstation_ip" {}

# certificado
variable "certificado_arn" {}
variable "prefix_core_dns" {}
variable "domain_name" {}
variable "public_zone_id" {}