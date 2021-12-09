provider "aws" {
  region = "${var.aws_region}"
}

# Create ECR repository
resource "aws_ecr_repository" "repository" {
  for_each = toset(var.list_local_repos)
    name   = element(split(":","${each.key}"),0)
}

# Push images from local Registry  to AWS ECR
module "ecr_mirror" {
  source  = "TechToSpeech/ecr-mirror/aws"
  aws_account_id = "${var.aws_account_id}"
  aws_region     = "${var.aws_region}" #$2
  aws_profile    = "default"

  for_each = toset(var.list_local_repos)

  docker_source = "${var.local_registry_url}/${each.key}" #$1
  ecr_repo_name = "${element(split(":","${each.key}"),0)}" #$4
  ecr_repo_tag  = "${element(split(":","${each.key}"),1)}" #$5
}
