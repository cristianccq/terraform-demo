variable "prefix" {}
variable "env" {}
variable "region" {}

# outputs from vpc
variable "vpc_id" {}

# route53
variable "private_zone_name" {}

# dns from alb
variable "alb_core_dns" {}
variable "alb_actions_dns" {}
variable "alb_duckling_dns" {}
variable "endpoint_rds" {}