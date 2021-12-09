
output "vpc_id" {
  value = "${aws_vpc.ecs-vpc.id}"
}

# ECS network configuration needs these.
output "ecs_private_subnet_ids" {
  value = aws_subnet.ecs-private-subnet.*.id
}

output "alb_public_subnet_ids" {
  value = aws_subnet.alb-public-subnet.*.id
}

# output for bastion
output "public_subnet_id" {
  value = aws_subnet.alb-public-subnet.*.id
}
output "public_subnet_sg" {
  value = "${aws_security_group.nat-public-subnet-sg.id}"
}

output "private_subnet_sg" {
  value = "${aws_security_group.https-private-sg.id}"
}

# output "nat_public_subnet_id" {
#   value = aws_subnet.nat-public-subnet.id
# }


output "internet_gateway_id" {
  value = ["${aws_internet_gateway.internet-gateway.id}"]
}


output "ecs_subnet_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value = aws_subnet.ecs-private-subnet.*.cidr_block
}

# ECS needs to know the availability zone names used for ECS cluster.
output "ecs_subnet_availability_zones" {
  value = var.azs
}



output "nat_public_subnet_sg_id" {
  value = "${aws_security_group.nat-public-subnet-sg.id}"
}

