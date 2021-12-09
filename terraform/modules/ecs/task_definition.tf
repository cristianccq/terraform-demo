data "template_file" "core-td-template" {
  template = file("${path.module}/task-definitions-templates/task-definition-core.json.template")
  vars  = {
    ecr_image_core_url            = "${var.ecr_image_core_url}:${var.ecr_image_core_tag}"
    fargate_container_memory = "${var.fargate_container_memory}"
    fargate_container_cpu    = "${var.fargate_container_cpu}"
    avb_core_port                 = "${var.avb_core_port}"
    container_name = "${local.my_name}-core-container"
  }
}
data "template_file" "actions-td-template" {
  template = file("${path.module}/task-definitions-templates/task-definition-actions.json.template")
  vars  = {
    ecr_image_actions_url            = "${var.ecr_image_actions_url}:${var.ecr_image_core_tag}"
    fargate_container_memory = "${var.fargate_container_memory}"
    fargate_container_cpu    = "${var.fargate_container_cpu}"
    avb_actions_port                 = "${var.avb_actions_port}"
    container_name = "${local.my_name}-actions-container"
  }
}
data "template_file" "duckling-td-template" {
  template = file("${path.module}/task-definitions-templates/task-definition-duckling.json.template")
  vars  = {
    ecr_image_duckling_url            = "${var.ecr_image_duckling_url}:${var.ecr_image_duckling_tag}"
    fargate_container_memory = "${var.fargate_container_memory}"
    fargate_container_cpu    = "${var.fargate_container_cpu}"
    avb_duckling_port                 = "${var.avb_duckling_port}"
    container_name = "${local.my_name}-duckling-container"
  }
}

resource "aws_ecs_task_definition" "ecs-core-task-definition" {
  family                   = "${local.my_name}-core-task-definition"
  memory                   = "${var.fargate_container_memory}"
  cpu                      = "${var.fargate_container_cpu}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.avb-ecs-task-execution-role.arn}"
  

  # .
  container_definitions    = data.template_file.core-td-template.rendered

  ephemeral_storage {
    size_in_gib = var.ephemeral_storage
  }


  tags =  {
    Name        = "${local.my_name}-core-task-definition"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}

resource "aws_ecs_task_definition" "ecs-actions-task-definition" {
  family                   = "${local.my_name}-actions-task-definition"
  memory                   = "${var.fargate_container_memory}"
  cpu                      = "${var.fargate_container_cpu}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.avb-ecs-task-execution-role.arn}"
  task_role_arn       = "${aws_iam_role.avb-ecs-task-execution-role.arn}"

  # .
  container_definitions    = data.template_file.actions-td-template.rendered

  tags =  {
    Name        = "${local.my_name}-actions-task-definition"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}

resource "aws_ecs_task_definition" "ecs-duckling-task-definition" {
  family                   = "${local.my_name}-duckling-task-definition"
  memory                   = "${var.fargate_container_memory}"
  cpu                      = "${var.fargate_container_cpu}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.avb-ecs-task-execution-role.arn}"

  # .
  container_definitions    = data.template_file.duckling-td-template.rendered


  tags =  {
    Name        = "${local.my_name}-duckling-task-definition"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}