locals {
  my_name  = "${var.prefix}-${var.env}-ecs"
  my_deployment   = "${var.prefix}-${var.env}"

  # cantidad de buckets
  buckets_count = length(var.bucket_list)

  buckets_private_count = length(var.bucket_private_list)

}

# Crear bucket
# resource "aws_s3_bucket" "create-buckets" {
  
#   count = local.buckets_count

#   bucket = element(var.bucket_list, count.index)
#   acl    = "private" 

#   tags = {
#     Name        = "${local.my_name}-bucket-${count.index+1}"
#     Deployment  = "${local.my_deployment}"
#     Prefix      = "${var.prefix}"
#     Environment = "${var.env}"
#     Region      = "${var.region}"
#     Terraform   = "true"
#   }

# }

# --------------------------------------------------
# public bucket
module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"
  # insert the 5 required variables here
  count = local.buckets_count

  bucket        = element(var.bucket_list, count.index)
  acl           = "public-read"
  force_destroy = true
  restrict_public_buckets = false

  attach_policy = true
  #policy        = data.aws_iam_policy_document.bucket_policy.json
  policy        = element(data.aws_iam_policy_document.bucket_policy, count.index).json


  tags = {
    Name        = "${local.my_name}-bucket-${count.index+1}"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

  versioning = {
    enabled = true
  }

}

module "s3-bucket-private" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"
  # insert the 5 required variables here
  count = local.buckets_private_count

  bucket        = element(var.bucket_private_list, count.index)
  
  restrict_public_buckets = true

  
  tags = {
    Name        = "${local.my_name}-bucket-${count.index+1}"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }

  versioning = {
    enabled = true
  }

}

