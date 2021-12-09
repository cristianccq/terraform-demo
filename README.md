
# Descripción
Implementar contenedores en Fargate


# AWS Solution

La arquitectura en AWS propuesta es la siguiente.


Los recursos usados por terraform estan documentados en su web oficial : [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](Docs)



Ejecución por separado, carpeta "manual_commands":
- s3 bucket - Public media content
- ECR images

# Enviroment Variables to setting 

- Credentials for RDS
    - export TF_VAR_username=xxxxx
    - export TF_VAR_password=xxxxx


# Deployment Instructions

Install Terraform. 
Comandos usuales : 
- terraform init
- terraform plan
- terraform apply
- terraform destroy

# Terraform Code

Una buena practica es modularizar la infraestructura para crear copiar de los recursos y ser replicables.

1. **Environment parameters**. En [envs] folder se definen entornos. Para crear un nuevo entorno crear otra carpeta y usar los modulos existentes, crear carpeta con el nombre "qa, prod, test ".
2. **Environment definition**. In [env-def] folder definimos los modulos que se usaran por entorno. 
3. **Modules**. In [modules] folder tenemos los modulos configurados por  environment definition (env-def, terraform module ).
4. **Tools**. Herramientas para subir imagenes de un docker Hub local . 

# Demo Application

Se ejecuta el bot de Rasa, asegurarse de usar la herramienta tools para subir imágenes al ECR o subirlas manualmente.
Verificar que cada docker contenga su healtcheck


# Terraform Modules

## VPC module

- 1 vpc
- 2 zonas
- 2 subnets publicas
- 2 subnets privadas
- 2 subnets para BD
- security groups
- tablas de ruteo
- internet gateway
- 2 nat gateway
- 2 elastic ip
- Bucket List
- RDS Cluster con politicas de mantenimiento y Backup

Definicion del vpc
admin_workstation_ip : es utilizado para crear los security groups y dar acceso para conectarse a la ip definida en esta variable



## ECS module
- IAM role for ECS task execution ( + role policy)
- ECS cluster
- ECS task definition
- Application load balancer (+ listener and target group)
- ECS service
- AutoScaling

## RDS modules
- PostgresSQL 
- Replica en otra zona de disponibilidad

## Route53 modules
- Creación de una Zona privada
- Asigna los dns de los load balancer a registros
- Permite la conectividad entre tasks
- En caso se tenga el dominio en zona Pública para el balanceador del core, descomentar esta seccin en el modulo.

## Bastion
- Keys
- Ejecucion de comandos de instalacion 

## VPC
- General VPC
- Natgateway
- Internet Gateway
- Sub Redes
- Tablas de ruteo
- IP Elasticas

* Nuevo: Agregado security group para HTTPS , usado en el private api

## Bucket
- General Bucket 

## Private-Api

* Requiere un proyecto en SAM utilizando vpc endpoints
* Una vez desplegado en aws, descomentar el modulo y llenar las variables
* Variables a usar:
- vpc ID
- Private vpc ids, 2 zonas de disponibilidad
- dns publico con certificados
- certificado para el nombre a usar con la api gateway
- ip's de los vpc endpoints ( Revisar la seccion Puntos de Enlace en AWS VPC)
- ID del APiGateway (se extrae del url http://<id>.execute-api.amazonaws.com)

* Los certificados se crean con AWS Certificate-Manager, necesitar tener dns de un sitio publico


Recursos a crear:
- zona privada en route53
- registro de route 53 con alias para el load balancer
- load balancer
- target group
- listener


* Destroy : Se debe destruir los recursos creador y el SAM apigateway  primero
