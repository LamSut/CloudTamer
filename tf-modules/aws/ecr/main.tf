terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_ecr_repository" "ecr_repos" {
  for_each             = toset(var.ecr_repo_names)
  name                 = each.value
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
  force_delete         = var.ecr_force_delete

  image_tag_mutability_exclusion_filter {
    filter      = "latest*"
    filter_type = "WILDCARD"
  }
}
