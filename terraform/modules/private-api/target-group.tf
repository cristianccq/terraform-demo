 # target group Core
resource "aws_alb_target_group" "vpc-endpoints-target-group" {
  name        = "${local.my_name}-vpcendpoint-tg"
  port        = "443"
  protocol    = "HTTPS"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"
  // La applicacion debe tener un healthcheck
  health_check {
    path = "/"
    matcher = "200,403"
    interval = "10"
    protocol = "HTTPS"
  }

  tags = {
    Name        = "${local.my_name}-alb-endpoint-tg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

## Attach resources to target group
resource "aws_alb_target_group_attachment" "endpoint1" {
  target_group_arn = aws_alb_target_group.vpc-endpoints-target-group.arn
  target_id        = "${var.ip-endpoint1}" # aca va la ip
  port             = 443
}

resource "aws_alb_target_group_attachment" "endpoint2" {
  target_group_arn = aws_alb_target_group.vpc-endpoints-target-group.arn
  target_id        = "${var.ip-endpoint2}" # aca va la ip
  port             = 443
}