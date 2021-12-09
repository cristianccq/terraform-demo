# NOTA: Esta es la definición de entorno que utilizarán todos los entornos.
# Los entornos reales (como dev) simplemente inyectan sus valores dependientes del entorno
# a este módulo env-def que define el entorno real y crea ese entorno
# inyectando los valores relacionados con el entorno a los módulos.

# NOTE: En esta seccion se puede activar/desactivar el RDS
# 1. Commentar el modulo RDS si no se desea

locals {
  my_name  = "${var.prefix}-${var.env}"
  my_env   = "${var.prefix}-${var.env}"
}

# Permite extraer datos de la cuenta configurada
data "aws_caller_identity" "current" {}

# modulo VPC
module "vpc" {
  source                = "../vpc"
  prefix                = "${var.prefix}"
  env                   = "${var.env}"
  region                = "${var.region}"
  vpc_cidr_block        = "${var.vpc_cidr_block}"
  private_subnet_count  = "${var.private_subnet_count}"
  admin_workstation_ip  = "${var.admin_workstation_ip}"
  azs                   = var.availability_zones


  # Definir Subredes
  private_subnets       = "${var.list_private_subnets}"
  public_subnets        = "${var.list_public_subnets}"
  database_subnets      = "${var.list_database_subnets}"

  # para los grupos de seguridad del balanceador
  # usamos los puertos
  avb_core_port         = "${var.avb_core_port}"
  avb_actions_port      = "${var.avb_actions_port}"
  avb_duckling_port     = "${var.avb_duckling_port}"

}

# Modulo para el private apigateway
# Comentar esta seccion antes de ejecutar el SAM lambda
# Descomentar despues del deploy
module "privateapi" {
  source = "../private-api"
  prefix                = "${var.prefix}"
  env                   = "${var.env}"
  region                = "${var.region}"

  vpc_id                = "${module.vpc.vpc_id}"
  private_subnet_ids    = module.vpc.ecs_private_subnet_ids

  domain_name           = var.domain_name
  prefix_dns            = var.prefix_dns #Custom DNS
  certificado_arn       = var.certificado_arn
  id_apigateway         = var.id_apigateway

  ip-endpoint1           = var.ip-endpoint1
  ip-endpoint2           = var.ip-endpoint2  

  alb_private_arn        = module.ecs.alb_private_arn
  alb_private_dns_name   = module.ecs.alb_private_dns_name
  alb_private_zone_id    = module.ecs.alb_private_zone_id
}


# #Modulo s3: Permite crear buckets a partir de una lista
module "buckets" {
  source     = "../bucket-s3"

  prefix                       = "${var.prefix}"
  env                          = "${var.env}"
  region                       = "${var.region}"
  # buckets publicos
  bucket_list                  = "${var.bucket_list}"
  # buckets privados
  bucket_private_list           = "${var.bucket_private_list}"

}

# Modulo cloudfront
module "cloudfront" {
  source     = "../cloudfront"

  prefix                       = "${var.prefix}"
  env                          = "${var.env}"
  region                       = "${var.region}"

  bucket_name                 =  var.cdn_bucket_name
  domain_name                 =  "${var.domain_name}"
  prefix_alias                =  "${var.prefix_alias}"
  domain_zone_id              =  "${var.public_zone_id}"
  path_index_file             =  "${var.path_index_file}"
  certificado_arn             =  "${var.certificado_arn}"

  git_url_repo                = var.git_url_repo
  temporal_path               = var.temporal_path
  repo_folder_index           = var.repo_folder_index

  depends_on = [
    module.buckets
  ]

}


# # Modulos ECS : Se encarga de crear los task en fargate
# # y asignarles un load balancer
module "ecs" {
  source                       = "../ecs"

  depends_on = [
    module.vpc
  ]

  admin_workstation_ip  = "${var.admin_workstation_ip}"

  prefix                       = "${var.prefix}"
  env                          = "${var.env}"
  region                       = "${var.region}"
  ecs_service_desired_count    = "${var.ecs_service_desired_count}"
  ecs_private_subnet_az_names  = "${module.vpc.ecs_subnet_availability_zones}"
  fargate_container_memory     = "${var.fargate_container_memory}"
  fargate_container_cpu        = "${var.fargate_container_cpu}"
  ecs_private_subnet_ids       = "${module.vpc.ecs_private_subnet_ids}"
  alb_public_subnet_ids        = "${module.vpc.alb_public_subnet_ids}"
  vpc_id                       = "${module.vpc.vpc_id}"
  aws_account_id               = "${data.aws_caller_identity.current.account_id}"

  # Recursos core
  ecr_image_core_url           = "${var.ecr_url_core_repo}"
  ecr_image_core_tag           = "${var.ecr_image_core_tag}"
  avb_core_port                     = "${var.avb_core_port}"
  ephemeral_storage                 = var.ephemeral_storage

  # Recursos actions
  ecr_image_actions_url                = "${var.ecr_url_actions_repo}"
  ecr_image_actions_tag                = "${var.ecr_image_actions_tag}"
  avb_actions_port                     = "${var.avb_actions_port}"

  # Recursos duckling
  ecr_image_duckling_url                = "${var.ecr_url_duckling_repo}"
  ecr_image_duckling_tag                = "${var.ecr_image_duckling_tag}"
  avb_duckling_port                     = "${var.avb_duckling_port}"

  # Para el core con HTTPS
  certificado_arn                   = var.certificado_arn
  prefix_core_dns                   = var.prefix_core_dns
  domain_name                       = var.domain_name
  public_zone_id                    = var.public_zone_id
}


# Modulo RDS
module "rds" {
  # ----- Tags--------
  source                = "../rds-cluster"
  prefix                = "${var.prefix}"
  env                   = "${var.env}"
  region                = "${var.region}"

  # ----- VPC --------
  vpc_cidr_block        = "${var.vpc_cidr_block}"
  vpc_id                = "${module.vpc.vpc_id}"
  private_subnet_count  = "${var.private_subnet_count}"
  admin_workstation_ip  = "${var.admin_workstation_ip}"
  availability_zones    = var.availability_zones

  # Definir Subredes
  list_database_subnets      = "${var.list_database_subnets}"

  # ------- RDS --------
  identifier                = var.identifier
  # Master y Replica
  name                      = var.name
  username                  = var.username
  password                  = var.password
  port_db                   = var.port_db 
  multi_az                  = var.multi_az

  # tipo de instacia
  engine                    = var.engine               
  engine_version            = var.engine_version       
  family                    = var.family               # DB parameter group
  major_engine_version      = var.major_engine_version # DB option group
  instance_class            = var.instance_class       

  allocated_storage         = var.allocated_storage    
  max_allocated_storage     = var.max_allocated_storage
  storage_encrypted         = var.storage_encrypted    

  publicly_accessible       = var.publicly_accessible  # Para red Privada

  # backup
  backup_retention_period   = var.backup_retention_period
  skip_final_snapshot       = var.skip_final_snapshot    
  deletion_protection       = var.deletion_protection

  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window

  # para subir los scripts a s3
  bucket_temp               = element(module.buckets.bucket_list, 0)

  depends_on = [
    module.buckets
  ]

}

# Modulo para el bastion host
module "bastion" {
  # ----- Tags--------
  source                    = "../bastion"
  prefix                    = "${var.prefix}"
  env                       = "${var.env}"
  region                    = "${var.region}"

  # ----- VPC --------    
  vpc_id                    = "${module.vpc.vpc_id}"
  public_subnet_id          = module.vpc.public_subnet_id
  public_subnet_sg          = module.vpc.public_subnet_sg

  # bastion instance type
  bastion_instance_type = var.bastion_instance_type
  # llaves 
  ssh_key_path     = var.ssh_key_path
  generate_ssh_key  = true

  # para ejecutar scripts rds 
  bucket_temp               = element(module.buckets.bucket_list, 0)
  depends_on = [
    module.rds, module.buckets
  ]
  pg_username               = "${module.rds.db_username}"
  pg_password               = "${module.rds.db_password}"
  pg_endpoint = element(split(":","${module.rds.db_instance_endpoint}"), 0)

}

# Modulo para el route53
module "route" {
  # ----- Tags--------
  source                    = "../route53"
  prefix                    = "${var.prefix}"
  env                       = "${var.env}"
  region                    = "${var.region}"

  # ----- route53   
  private_zone_name         = "${var.private_zone_name}"
  alb_core_dns              = "${module.ecs.alb_public_dns_name}"
  alb_actions_dns           = "${module.ecs.alb_private_dns_name}"
  alb_duckling_dns          = "${module.ecs.alb_private_dns_name}"  # repetir por ahora
  # formatear "${module.rds.db_instance_endpoint}"
  # contiene el puerto
  endpoint_rds              = element(split(":","${module.rds.db_instance_endpoint}"), 0)

  # ----- VPC --------    
  vpc_id                    = "${module.vpc.vpc_id}"


}