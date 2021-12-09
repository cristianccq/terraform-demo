locals {
  my_name  = "${var.prefix}-${var.env}-ecs"
  my_deployment   = "${var.prefix}-${var.env}"
}

# Crear zona privada
resource "aws_route53_zone" "private_zone" {
  name = "${var.private_zone_name}"

  vpc {
    vpc_id = var.vpc_id
  }
}

# registrar dns de balanceadores
resource "aws_route53_record" "record-actions-alb" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "actions" # nombre del registro actions.example.com
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "actions"
  records        = ["${var.alb_actions_dns}"]
}

resource "aws_route53_record" "record-duckling-alb" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "duckling" # nombre del registro duckling.example.com
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "duckling"
  records        = ["${var.alb_duckling_dns}"]
}

resource "aws_route53_record" "record-postgres-alb" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "postgres" # nombre del registro postgres.example.com
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "postgres"
  records        = ["${var.endpoint_rds}"]
}

## Dns para el core, si es publico debe estar registrado 
# y tener dominio
resource "aws_route53_record" "record-core-alb" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "coreinterno" # nombre del registro core.example.com
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "coreinterno"
  records        = ["${var.alb_core_dns}"]
}