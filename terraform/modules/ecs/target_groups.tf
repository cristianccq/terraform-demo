 # target group Core
resource "aws_alb_target_group" "ecs-public-alb-target-group" {
  name        = "${local.my_name}-core-tg"
  port        = "${var.avb_core_port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"
  // La applicacion debe tener un healthcheck
  health_check {
    path = "/status"
    matcher = "200"
    interval = "10"
    protocol = "HTTP"
  }

  tags = {
    Name        = "${local.my_name}-alb-core-tg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

# target group ACTIONS
resource "aws_alb_target_group" "ecs-private-alb-target-group" {
  name        = "${local.my_name}-actions-tg"
  port        = "${var.avb_actions_port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"
  // La applicacion debe tener un healthcheck
  // 7005 es un port adicional no configurado
  health_check {
    path = "/health"
    matcher = "200"
    interval = "10"
    protocol = "HTTP"
  }

  tags = {
    Name        = "${local.my_name}-alb-actions-tg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

# target group Duckling
resource "aws_alb_target_group" "ecs-alb-duckling-target-group" {
  name        = "${local.my_name}-duckling-tg"
  port        = "${var.avb_duckling_port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"
  // La applicacion debe tener un healthcheck
  health_check {
    path = "/"
    matcher = "200"
    interval = "10"
    protocol = "HTTP"
  }

  tags = {
    Name        = "${local.my_name}-alb-duckling-tg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}