output "ecr_name" {
  description = "URL ECR репозиторію"
  value       = aws_ecr_repository.this.repository_url
}