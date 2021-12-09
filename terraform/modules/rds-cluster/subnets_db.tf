
# Subnets DB, public and private
resource "aws_subnet" "public_db_subnet" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = element(var.list_database_subnets, 0)
  availability_zone = element(var.availability_zones, 0)

  tags = {
    Name = "${local.my_name}-private-db"
  }
}
resource "aws_subnet" "private_db_subnet" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = element(var.list_database_subnets, 1)
  availability_zone = element(var.availability_zones, 1)

  tags = {
    Name = "${local.my_name}-private-db"
  }
}

# create security group , postgres DB port
resource "aws_security_group" "postgres-sg" {
  name        = "${local.my_name}-postgres-sg"
  description = "Postgressg"
  vpc_id      = "${var.vpc_id}"

  # sql requiere tcp puerto 5432
  ingress {
    protocol    = "tcp"
    from_port   = local.port_db
    to_port     = local.port_db
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
    Name        = "${local.my_name}-postgres-sg"
    Terraform   = "true"
  }
}