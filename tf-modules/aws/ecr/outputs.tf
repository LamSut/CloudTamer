output "ecr_rpo_uris" {
  description = "ECR Repository URI"
  value       = { for repo_name, repo in aws_ecr_repository.ecr_repos : repo_name => repo.repository_url }
}
