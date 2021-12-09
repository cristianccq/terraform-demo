
locals {
  bucket_name = "${var.bucket_name}"
}

resource "null_resource" "clone_repo" {
  provisioner "local-exec" {
    command = "git clone ${var.git_url_repo} ${var.temporal_path}"
  }
}

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${var.temporal_path}/${var.repo_folder_index} s3://${local.bucket_name}"
  }
}

module "cdn" {
  source = "cloudposse/cloudfront-s3-cdn/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version     = "0.78.0"

  origin_bucket     = "${local.bucket_name}"
  override_origin_bucket_policy = false

  aliases           = ["${var.prefix_alias}.${var.domain_name}"]
  dns_alias_enabled = true
  logging_enabled = false
  #parent_zone_name  = "demo-avb-hdi.click"
  parent_zone_id  = "${var.domain_zone_id}"
  default_root_object = "${var.path_index_file}"

  acm_certificate_arn = "${var.certificado_arn}"

  name                          = "cdn"
  stage                         = "${var.env}"
  namespace                     = "${var.prefix}"

  depends_on = [null_resource.remove_and_upload_to_s3]
}



resource "null_resource" "remove_clone" {
  provisioner "local-exec" {
    command = "rm -r ${var.temporal_path}/"
  }
  depends_on = [
    module.cdn
  ]
}
