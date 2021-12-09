locals {
  my_name  = "${var.prefix}-${var.env}-ecs"
  my_deployment   = "${var.prefix}-${var.env}"
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${local.my_name}-cluster"

  tags  = {
    Name        = "${local.my_name}-cluster"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}


resource "aws_ecs_service" "ecs-core-service" {
  name            = "${local.my_name}-core-service"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  launch_type     = "FARGATE"
  desired_count   = "${var.ecs_service_desired_count}"
  task_definition = "${aws_ecs_task_definition.ecs-core-task-definition.arn}"

  network_configuration {
    subnets = var.alb_public_subnet_ids
    security_groups = ["${aws_security_group.alb-public-subnet-sg.id}"]
    assign_public_ip = true
  }

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-public-alb-target-group.arn}"
    container_name   = "${local.my_name}-core-container"
    container_port   = "${var.avb_core_port}"
  }

  depends_on = [
    aws_alb_listener.alb_listener_core
  ]

  tags = {
    Name        = "${local.my_name}-service-core"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}

resource "aws_ecs_service" "ecs-actions-service" {
  name            = "${local.my_name}-actions-service"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  launch_type     = "FARGATE"
  desired_count   = "${var.ecs_service_desired_count}"
  task_definition = "${aws_ecs_task_definition.ecs-actions-task-definition.arn}"

  network_configuration {
    subnets = var.ecs_private_subnet_ids
    security_groups = ["${aws_security_group.ecs-private-subnet-sg.id}"]
    #assign_public_ip = true
  }

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-private-alb-target-group.arn}"
    container_name   = "${local.my_name}-actions-container"
    container_port   = "${var.avb_actions_port}"
  }

  depends_on = [
    aws_alb_listener.alb_listener_actions
  ]

  tags = {
    Name        = "${local.my_name}-service-actions"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}

resource "aws_ecs_service" "ecs-duckling-service" {
  name            = "${local.my_name}-duckling-service"
  # nombre del cluster es el id
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  launch_type     = "FARGATE"
  desired_count   = "${var.ecs_service_desired_count}"
  task_definition = "${aws_ecs_task_definition.ecs-duckling-task-definition.arn}"

  

  network_configuration {
    subnets = var.ecs_private_subnet_ids
    security_groups = ["${aws_security_group.ecs-private-subnet-sg.id}"]
    #assign_public_ip = true
  }

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-alb-duckling-target-group.arn}"
    container_name   = "${local.my_name}-duckling-container"
    container_port   = "${var.avb_duckling_port}"
  }

  depends_on = [
    aws_alb_listener.alb_listener_duckling
  ]


  tags = {
    Name        = "${local.my_name}-service-duckling"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}

