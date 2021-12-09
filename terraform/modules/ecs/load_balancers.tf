# Application load balancer (ALB) 
# Balancea la carga entre tareas ejecutadas en la red publica
resource "aws_alb" "ecs-public-alb" {
  name               = "${local.my_name}-alb-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb-public-subnet-sg.id}"]
  subnets            = var.alb_public_subnet_ids
  //enable_deletion_protection = true

  tags = {
    Name        = "${local.my_name}-alb-public"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

resource "aws_alb_listener" "alb_listener_core" {
  load_balancer_arn = "${aws_alb.ecs-public-alb.arn}"
  port              = "${var.avb_core_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-public-alb-target-group.arn}"
    type             = "forward"
  }
}

# ----------- LOAD BALANCER PRIVATE  ---------------

resource "aws_alb" "ecs-private-alb" {
  name               = "${local.my_name}-alb-private"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.ecs-private-subnet-sg.id}"]
  subnets            = var.ecs_private_subnet_ids
  //enable_deletion_protection = true

  tags = {
    Name        = "${local.my_name}-alb-private"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

resource "aws_alb_listener" "alb_listener_actions" {
  load_balancer_arn = "${aws_alb.ecs-private-alb.arn}"
  port              = "${var.avb_actions_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-private-alb-target-group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb_listener_duckling" {
  load_balancer_arn = "${aws_alb.ecs-private-alb.arn}"
  port              = "${var.avb_duckling_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-alb-duckling-target-group.arn}"
    type             = "forward"
  }
}