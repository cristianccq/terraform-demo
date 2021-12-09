# utilizar bucket
# upload file scripts.zip
resource "aws_s3_bucket_object" "object" {

  bucket = "${var.bucket_temp}" 
  key    = "scripts.zip"

  acl    = "private"  # or can be "public-read"
  source = "${path.module}/scripts.zip"


}