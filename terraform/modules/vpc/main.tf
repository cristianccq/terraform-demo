locals {
  my_name  = "${var.prefix}-${var.env}-vpc"
  my_deployment   = "${var.prefix}-${var.env}"

  # cantidad de nat_gateway
  nat_gateway_count = length(var.azs)

  # Nat gateway ips
  nat_gateway_ips = split(
    ",",
     join(",", aws_eip.nat-gw-eip.*.id),
  )
}

######################################################################
#  VPC                                                               #
######################################################################
# Crear vpc con el bloque respectivo
# recordar habilitar  dns_hostname y dns_support
# Necesarios para la comunicacion con 
# RDS, private DNS, route53
resource "aws_vpc" "ecs-vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name        = "${local.my_name}"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

#recurso eip: generan ip elasticas
resource "aws_eip" "nat-gw-eip" {
  # necesitamos 2 eip
  count = local.nat_gateway_count
  vpc = true
  tags = {
    Name        = "${local.my_name}-nat-gw-eip"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}
# Necesitamos 2 nat gateways 
resource "aws_nat_gateway" "this" {
  count =  local.nat_gateway_count 

  allocation_id = element(
    local.nat_gateway_ips,
     count.index,
  )
  subnet_id = element(
    aws_subnet.alb-public-subnet.*.id,
     count.index,
  )

  depends_on = [aws_internet_gateway.internet-gateway]

  tags = {
    Name        = "${local.my_name}-nat-gw"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

######################################################################
#  Internet Gateway                                                  #
######################################################################
# Recurso : internet gateway : proporciona salida a internet
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"

  tags = {
    Name        = "${local.my_name}-ig"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

######################################################################
#  Subnets                                                           #
######################################################################
# subnets publicas con exposicion a internet.
resource "aws_subnet" "alb-public-subnet" {
  vpc_id            = "${aws_vpc.ecs-vpc.id}"
  count             = length(var.public_subnets)
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(concat(var.public_subnets, [""]), count.index)

  tags = {
    Name        = "${local.my_name}-${count.index+1}-alb-public-subnet"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

# Subnets privadas, sin salida a internet
resource "aws_subnet" "ecs-private-subnet" {
  count = length(var.private_subnets)

  vpc_id            = "${aws_vpc.ecs-vpc.id}"
  
  availability_zone = element(var.azs, count.index)

  cidr_block        = var.private_subnets[count.index]

  tags = {
    Name        = "${local.my_name}-${count.index+1}-ecs-private-subnet"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

######################################################################
#  Tablas de Ruteo                                                   #
######################################################################
# Tabla de ruteo con acceso al internet gateway
# para subnet pública
resource "aws_route_table" "alb-public-subnet-route-table" {
  
  vpc_id = "${aws_vpc.ecs-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }

  tags = {
    Name        = "${local.my_name}-alb-public-subnet-route-table"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

# Asociar la tabla de ruteo con cada subnet
resource "aws_route_table_association" "ecs-alb-public-subnet-route-table-association" {
  count          = "${var.private_subnet_count}"
  subnet_id      = "${aws_subnet.alb-public-subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.alb-public-subnet-route-table.id}"
}

# Para la Subred Privada, asociar un nat gateway acada una
resource "aws_route_table" "ecs-private-subnet-route-table" {
  count = local.nat_gateway_count

  vpc_id = "${aws_vpc.ecs-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
  }

  tags = {
    Name        = "${local.my_name}-ecs-private-subnet-route-table"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

# From our ECS private subnet to NAT.
resource "aws_route_table_association" "ecs-private-subnet-route-table-association" {
  count = "${var.private_subnet_count}"
  subnet_id      = element(aws_subnet.ecs-private-subnet.*.id, count.index) #"${aws_subnet.ecs-private-subnet.*.id[count.index]}"
  route_table_id = element(
    aws_route_table.ecs-private-subnet-route-table.*.id,
     count.index,
  ) #"${aws_route_table.ecs-private-subnet-route-table.id}"
}


