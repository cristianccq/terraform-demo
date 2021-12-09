# Politica exclusiva para permitir acceso de los objetos
data "aws_iam_policy_document" "bucket_policy" {

    count = local.buckets_count

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
      "arn:aws:s3:::${element(var.bucket_list, count.index)}/*",
    ]
  }
}
