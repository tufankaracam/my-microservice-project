output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Список ID публічних підмереж"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Список ID приватних підмереж"
  value       = module.vpc.private_subnets
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "ecr_repository_url" {
  description = "Повний URL (hostname/імена) для docker push/pull."
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN створеного репозиторію."
  value       = module.ecr.repository_arn
}

