output "bucket_name" {
  description = "Назва S3-бакета для стейтів"
  value       = module.s3_backend.bucket_name
}

output "table_name" {
  description = "Назва таблиці DynamoDB для блокування стейтів"
  value       = module.s3_backend.table_name
}