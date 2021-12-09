variable "prefix" {}
variable "env" {}
variable "region" {}

variable "bucket_list" {
  description = "Lista de buckets de s3"
  type        = list(string)
}

variable "bucket_private_list" {
  description = "Lista de buckets de s3"
  type        = list(string)
}