# Entorno de Desarrollo
##### Terraform configuration #####

locals {
  # Region: virginia
  my_region                 = "us-east-1"
  availability_zones = ["us-east-1a","us-east-1b"]
  
  # Entorno de Desarrollo
  my_env                    = "dev"
  my_prefix                 = "avb-hdi"
  vpc_cidr_block            = "10.0.0.0/16"

  # ------- Workstation IP ---------
  # admin_workstation_ip : ip para probar los security groups
  # y permitir acseso a la ip , usar 0.0.0.0/0 para cualquier origen
  admin_workstation_ip      = "0.0.0.0/0"

}

terraform {
  required_version = ">=0.11.11"
}

provider "aws" {
  region     = "${local.my_region}"
}


# Variables a utilizar para todos los modulos
module "env-def" {
  source                    = "../../modules/env-def"
  prefix                    = "${local.my_prefix}"
  env                       = "${local.my_env}"
  region                    = "${local.my_region}"
  vpc_cidr_block            = "${local.vpc_cidr_block}"
  private_subnet_count      = "2" # adaptado para 2 subnets
  admin_workstation_ip      = "${local.admin_workstation_ip}"
  availability_zones        = local.availability_zones 
  bastion_instance_type     = "t2.micro"
  ssh_key_path              = "./secrets"

  # subnet blocks
  list_public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  list_private_subnets      = ["10.0.0.0/24", "10.0.1.0/24"]
  list_database_subnets     = ["10.0.2.0/24", "10.0.3.0/24"]

  # ----- FARGATE ECS -----------
  ecs_service_desired_count = "1"
  fargate_container_memory  = "2048"
  fargate_container_cpu     = "1024"

  # Core
  ecr_url_core_repo         = "425178540181.dkr.ecr.us-east-1.amazonaws.com/avb_hdi_image_core_nlu"
  ecr_image_core_tag        = "latest"
  avb_core_port             = "5005"
  ephemeral_storage         = 21

  # actions
  ecr_url_actions_repo      = "425178540181.dkr.ecr.us-east-1.amazonaws.com/avb_hdi_image_actions"
  ecr_image_actions_tag     = "latest"
  avb_actions_port          = "4848"

  # duckling
  ecr_url_duckling_repo     = "425178540181.dkr.ecr.us-east-1.amazonaws.com/avb_hdi_duckling_image"
  ecr_image_duckling_tag    = "latest"
  avb_duckling_port         = "8000"

  # ------- RDS --------
  identifier                = "rds-db"
  # Master y Replica
  name                      = "cluster-hdi-avb"
  username                  = var.username
  password                  = var.password
  port_db                   = "5432"
  multi_az                  = true

  # tipo de instacia
  engine                    = "aurora-postgresql"
  engine_version            = "11.12"
  family                    = "postgres11" # DB parameter group
  major_engine_version      = "11"         # DB option group
  instance_class            = "db.t3.medium" # tipo de instancia

  allocated_storage         = 20  # almacenamiento asignado en GB
  max_allocated_storage     = 100 # valor maximo para autoescalado
  storage_encrypted         = false  # especifica si la bd esta encriptada

  publicly_accessible       = false  # Para red Privada

  # backup
  backup_retention_period   = 30  # dias para retener el backup
  skip_final_snapshot       = true
  deletion_protection       = false
  # adicional , hora de backup en UTC 0 , no debe cruzarce con mantenimiento
  backup_window             = "09:46-10:16"  
  # mantenimiento Syntax: 'ddd:hh24:mi-ddd:hh24:mi'
  maintenance_window        = "Mon:00:00-Mon:03:00"

  #Bucket de contenido público
  bucket_list = ["bucketz123"]
  # Bucket privado
  bucket_private_list = ["bucketasd1"]

  #  ------ route 53 --------
  private_zone_name = "myrasabot.com"

  # --------- Private Api Gateway ---------------
  domain_name           = "demo-avb-hdi.click"
  public_zone_id        = "Z095288916R0RQGCOLC4"
  prefix_dns            = "know" #Custom DNS
  # Certificado necesario para HTTPS
  # para exponer el core publicamente
  # y para un dns estatico del apigateway
  certificado_arn       = "arn:aws:acm:us-east-1:425178540181:certificate/f9890e28-057a-4ab7-ad0b-4d29077cd02b"

  id_apigateway         = "xyreu09o29"

  ip-endpoint1           = "10.0.0.4"
  ip-endpoint2           = "10.0.1.130"

  # DNS para el core en HTTPS
  prefix_core_dns         = "core"

  # ---------------- CloudFront -----------
  # se usa el bucket publico creado
  prefix_alias                =  "assets"
  path_index_file             =  "index.html"
  # usar un bucket publico creado previamente
  cdn_bucket_name             = "bucketz123"

  # Repositorio
  git_url_repo                = "http://192.168.21.51:8989/bots/bytebot/avb-hdi.git"
  temporal_path               = "/tmp/tf_files"
  # carpeta del repo a subir al s3, se debe encontrar el index_file
  repo_folder_index           = "AVB-HDI-WEBVIEW"

}
