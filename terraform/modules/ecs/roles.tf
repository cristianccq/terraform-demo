# See: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_role" "avb-ecs-task-execution-role" {
  name = "${local.my_name}-task-execution-role"

  assume_role_policy = <<ROLEPOLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
ROLEPOLICY

  tags =  {
    Name        = "${local.my_name}-task-execution-role"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

# Adjuntar politicas
resource "aws_iam_role_policy_attachment" "avb-ecs-task-execution-role-policy-attachment" {
  role       = "${aws_iam_role.avb-ecs-task-execution-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "attachment-ecs" {
  role       = "${aws_iam_role.avb-ecs-task-execution-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
resource "aws_iam_role_policy_attachment" "attachment-textract" {
  role       = "${aws_iam_role.avb-ecs-task-execution-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
}
resource "aws_iam_role_policy_attachment" "attachment-textract-service" {
  role       = "${aws_iam_role.avb-ecs-task-execution-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonTextractServiceRole"
}
resource "aws_iam_role_policy_attachment" "attachment-s3" {
  role       = "${aws_iam_role.avb-ecs-task-execution-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
# Para probar en instancias ec2
resource "aws_iam_role_policy_attachment" "attachment-ec2-testing" {
  role       = "${aws_iam_role.avb-ecs-task-execution-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}