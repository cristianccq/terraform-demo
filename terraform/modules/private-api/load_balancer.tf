# Application load balancer (ALB) 
# # Balancea la carga entre los VPC Endpoint


resource "aws_alb_listener" "alb_listener_vpc-endpoint" {
  load_balancer_arn = "${var.alb_private_arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.certificado_arn}"


  default_action {
    target_group_arn = "${aws_alb_target_group.vpc-endpoints-target-group.arn}"
    type             = "forward"
  }
}
