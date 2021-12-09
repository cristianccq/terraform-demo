locals {
  my_name  = "${var.prefix}-${var.env}-ecs"
  my_deployment   = "${var.prefix}-${var.env}"

  #TODO: NO SE DEBE CREAR LA BD DESDE AQUI. Todas las sentencias SQL deben tomarse desde los Scripts
  
  pg_createdb = "export PGPASSWORD='${var.pg_password}'; psql -h ${var.pg_endpoint} -p 5432 -U ${var.pg_username} -c 'create database ${var.pg_db_core};'"
  pg_command = "export PGPASSWORD='${var.pg_password}'; psql -h ${var.pg_endpoint} -p 5432 -U ${var.pg_username} -d ${var.pg_db_core} -f scripts/script.sql"

  s3_bucket_db = "${var.bucket_temp}"
  # agregar a user_data en caso desee eliminar el script.zip
  s3_command_delete = "aws s3api delete-object --bucket ${var.bucket_temp} --key scripts.zip"
}

module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.18.0"
  attributes          = ["ssh", "key"]
  #public_key_extension= ".pem" # este archivo no es el pem
  ssh_public_key_path = var.ssh_key_path
  generate_ssh_key    = var.generate_ssh_key

}

module "ec2-bastion-server" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.28.3"
  # insert the 13 required variables here
  key_name                    = module.aws_key_pair.key_name
  name                        = "${var.prefix}-${var.env}-bastion"

  instance_type               = var.bastion_instance_type
  security_groups             = [var.public_subnet_sg]
  subnets                     = var.public_subnet_id 
  
  user_data                   = ["sleep 5m","sudo amazon-linux-extras install postgresql10 -y","aws s3 cp s3://${local.s3_bucket_db}/scripts.zip scripts.zip","unzip scripts.zip",local.pg_createdb,local.pg_command]
  vpc_id                      = var.vpc_id
  associate_public_ip_address = true

  tags = {
    Name        = "${local.my_name}-bastion"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

# Role attachment for s3 access
resource "aws_iam_role_policy_attachment" "bastion-s3-access" {
  role       = "${module.ec2-bastion-server.role}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}