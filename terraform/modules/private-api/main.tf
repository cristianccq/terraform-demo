locals {
  my_name  = "${var.prefix}-${var.env}-ecs"
  my_deployment   = "${var.prefix}-${var.env}"

  custom_dns_apigateway = "${var.prefix_dns}.${var.domain_name}"
}

# 
resource "aws_apigatewayv2_domain_name" "avb-dns" {
  domain_name = "${local.custom_dns_apigateway}"

  domain_name_configuration {
    certificate_arn = "${var.certificado_arn}"
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "avb-map" {
  api_id      = "${var.id_apigateway}"
  domain_name = aws_apigatewayv2_domain_name.avb-dns.id
  stage       = "api"
}

# Opcional, se puede usar la otra red privada creada en route53
# Default : Crear su propia red privada que coincide con el certificado
#  No debe existir una red privada con el mismo nombre
resource "aws_route53_zone" "private_api_zone" {
  name = "${var.domain_name}"

  vpc {
    vpc_id = var.vpc_id
  }
}


resource "aws_route53_record" "record_apigw" {
  name    = "${local.custom_dns_apigateway}"
  type    = "A"
  zone_id = "${aws_route53_zone.private_api_zone.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "dualstack.${var.alb_private_dns_name}"
    zone_id                = "${var.alb_private_zone_id}"
  }
}