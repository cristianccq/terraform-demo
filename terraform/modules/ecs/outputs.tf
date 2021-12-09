
# Query as: AWS_PROFILE=YOUR_AWS_PROFILE terraform output -module=env-def.ecs
output "alb_public_dns_name" {
  value = "${aws_alb.ecs-public-alb.dns_name}"
}


output "alb_private_dns_name" {
  value = "${aws_alb.ecs-private-alb.dns_name}"
}

output "alb_private_zone_id" {
  value = "${aws_alb.ecs-private-alb.zone_id}"
}



output "alb_private_arn" {
  value= "${aws_alb.ecs-private-alb.arn}"
}