variable "prefix" {}
variable "env" {}
variable "region" {}

variable "bucket_name" {}

variable "domain_name" {
    default = "demo-avb-hdi.click"
}

variable "prefix_alias" {
    default = "assets"
}

variable "domain_zone_id" {}

variable "path_index_file" {}

variable "certificado_arn" {}


variable "git_url_repo" {}
variable "temporal_path" {}
variable "repo_folder_index" {}