locals {
  my_name  = "${var.prefix}-${var.env}-ecs"
  my_deployment   = "${var.prefix}-${var.env}"
  port_db = var.port_db

  instance_type_writer  = "${var.instance_class}"
  instance_type_reader1 = "${var.instance_class}"
  instance_type_reader2 = "${var.instance_class}"
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.public_db_subnet.id, aws_subnet.private_db_subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}
################################################################################
# RDS
################################################################################

module "rds-aurora" {
  source                  = "terraform-aws-modules/rds-aurora/aws"
  version                 = "6.1.3"

  name                    = "${var.name}"
  # Versiones: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine                  = var.engine              
  engine_version          = var.engine_version 
 
 # 1 Writer 1 Reader

  instances = {
    1 = {
      instance_class      = local.instance_type_writer
      publicly_accessible = true
    }
    2 = {
      identifier     = "static-member-1"
      instance_class = local.instance_type_reader1
    }
    # 3 = {
    #   identifier     = "excluded-member-1"
    #   instance_class = local.instance_type_reader2
    #   promotion_tier = 15
    # }
  }


  # VPC conf
  vpc_id                  = var.vpc_id
  db_subnet_group_name    = aws_db_subnet_group.default.name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = ["${var.vpc_cidr_block}"]
  security_group_egress_rules = {
    to_cidrs = {
      cidr_blocks = ["${var.vpc_cidr_block}"]
    }
  }
  iam_database_authentication_enabled = true
  master_username                = var.username
  master_password                = var.password
  # Disable creation of random password - AWS API provides the password
  create_random_password = false

  apply_immediately       = true
  skip_final_snapshot     = var.skip_final_snapshot

  
  db_parameter_group_name         = aws_db_parameter_group.example.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id
  enabled_cloudwatch_logs_exports = ["postgresql"]

  publicly_accessible     = var.publicly_accessible

  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection # evita borrar la BD
  # adicional , hora de backup en UTC 0 , no debe cruzarce con mantenimiento
  preferred_backup_window             = var.backup_window
  preferred_maintenance_window        = var.maintenance_window

}
resource "aws_db_parameter_group" "example" {
  name        = "${local.my_name}-aurora-db-postgres11-parameter-group"
  family      = "aurora-postgresql11"
  description = "${local.my_name}-aurora-db-postgres11-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "example" {
  name        = "${local.my_name}-aurora-postgres11-cluster-parameter-group"
  family      = "aurora-postgresql11"
  description = "${local.my_name}-aurora-postgres11-cluster-parameter-group"
}