variable "ecr_name" {
  description = "Назва ECR репозиторію"
  type        = string
}

variable "scan_on_push" {
  description = "Enable automatic image scanning"
  type        = bool
  default     = true
}