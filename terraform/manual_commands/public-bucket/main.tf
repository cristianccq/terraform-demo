

# Politica exclusiva para permitir acceso de los objetos
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}


module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"
  # insert the 5 required variables here

  bucket        = local.bucket_name
  acl           = "public-read"
  force_destroy = true
  restrict_public_buckets = false

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json


  tags = local.tags

  versioning = {
    enabled = true
  }



#   cors_rule = [
#     {
#       allowed_methods = ["GET","PUT", "POST"]
#       allowed_origins = ["*"]
#       allowed_headers = ["*"]
#       expose_headers  = ["ETag"]
#       max_age_seconds = 3000
#       }, {
#       allowed_methods = ["PUT"]
#       allowed_origins = ["https://example.com"]
#       allowed_headers = ["*"]
#       expose_headers  = ["ETag"]
#       max_age_seconds = 3000
#     }
#   ]


}


module "s3-bucket-private" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"
  # insert the 5 required variables here

  bucket        = "${local.bucket_name}2"
  
  restrict_public_buckets = true

  
  tags = local.tags

  versioning = {
    enabled = true
  }

}
