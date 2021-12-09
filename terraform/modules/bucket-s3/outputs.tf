output "bucket_list" {
  value = module.s3-bucket.*.s3_bucket_id  #aws_s3_bucket.create-buckets.*.id
}


output "bucket_public_cdn" {
  value = module.s3-bucket.*.s3_bucket_id[0]
}