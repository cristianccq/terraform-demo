# security group para conectarse con instancias mediante SSH
resource "aws_security_group" "nat-public-subnet-sg" {
  name        = "${local.my_name}-nat-public-subnet-sg"
  description = "For testing purposes, create ingress rules manually"
  vpc_id      = "${aws_vpc.ecs-vpc.id}"

  # ssh requiere tcp puerto 22
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
    Name        = "${local.my_name}-nat-public-subnet-sg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}


# private sg, para acceso HTTPS
resource "aws_security_group" "https-private-sg" {
  name        = "${local.my_name}-https-private-sg"
  description = "HTTPS private"
  vpc_id      = "${aws_vpc.ecs-vpc.id}"

  # https requiere tcp puerto 443
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
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
    Name        = "${local.my_name}-nat-public-subnet-sg"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}
