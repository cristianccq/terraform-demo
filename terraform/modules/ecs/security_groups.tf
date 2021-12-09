
# security group para permitir acceso a los puertos de las tareas 
# en la RED PÚBLICA
resource "aws_security_group" "alb-public-subnet-sg" {
  name        = "${local.my_name}-alb-public-subnet-sg"
  description = "Allow inbound access to application port only, oubound to ECS"
  vpc_id      = "${var.vpc_id}"

  # Habilitar permiso al puerto del core
  ingress {
    protocol    = "tcp"
    from_port   = "${var.avb_core_port}"
    to_port     = "${var.avb_core_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Habilitar permiso HTTPS
  ingress {
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Para conectarse por ssh
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.admin_workstation_ip}"]
  }

  // Terraform removes the default rule.
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.my_name}-alb-public-subnet-sg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

}

# security group para permitir acceso a los puertos de las tareas 
# en la RED PRIVADA
resource "aws_security_group" "ecs-private-subnet-sg" {
  name        = "${local.my_name}-ecs-private-subnet-sg"
  description = "Allow inbound access from the ALB only"
  vpc_id      = "${var.vpc_id}"

  # Aceptar peticiones para el core
  ingress {
    protocol        = "tcp"
    from_port       = "${var.avb_core_port}"
    to_port         = "${var.avb_core_port}"
    cidr_blocks     = ["${var.admin_workstation_ip}"]
  }

  # https requiere tcp puerto 443 , para apigw
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]  # acceso desde cualquier origen en el vpc
  }

  # Permitir ssh
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.admin_workstation_ip}"]
  }

  # Aceptar peticiones para el action server
  ingress {
    protocol    = "tcp"
    from_port   = "${var.avb_actions_port}"
    to_port     = "${var.avb_actions_port}"
    cidr_blocks = ["${var.admin_workstation_ip}"]
  }

  # Aceptar peticiones para el duckling
  ingress {
    protocol    = "tcp"
    from_port   = "${var.avb_duckling_port}"
    to_port     = "${var.avb_duckling_port}"
    cidr_blocks = ["${var.admin_workstation_ip}"]
  }

  // Terraform removes the default rule.
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.my_name}-ecs-private-subnet-sg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}