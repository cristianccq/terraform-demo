# Listener con certificado
locals {
  custom_dns_apigateway = "${var.prefix_core_dns}.${var.domain_name}"
}



resource "aws_alb_listener" "alb_listener_certificate_core" {
  load_balancer_arn = "${aws_alb.ecs-public-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.certificado_arn}"


  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-public-alb-target-group.arn}"
    type             = "forward"
  }
}

# Crear registro HTTPS en el dominio publico
# necesita el DNS del balanceador

resource "aws_route53_record" "record_https" {
  name    = "${local.custom_dns_apigateway}"
  type    = "A"
  zone_id = "${var.public_zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "dualstack.${aws_alb.ecs-public-alb.dns_name}"
    zone_id                = "${aws_alb.ecs-public-alb.zone_id}"
  }
}

