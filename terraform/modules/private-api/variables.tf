variable "prefix" {}
variable "env" {}
variable "region" {}


variable "domain_name" {}

variable "prefix_dns" {}

variable "certificado_arn" {}

variable "id_apigateway" {
  description = "El id que se muestra en el apigateway : https://<id>.execute-api.us-east-1.amazonaws.com"
}

variable "vpc_id" {}
variable "private_subnet_ids" {}


# ip de endpoints
variable "ip-endpoint1" {}
variable "ip-endpoint2" {}

# private alb
variable "alb_private_arn" {}

variable "alb_private_dns_name" {}
variable "alb_private_zone_id" {}