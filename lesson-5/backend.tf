terraform {
  backend "s3" {
    bucket         = "tk-terraform-state-lesson5-000001"  # main.tf ile aynı olmalı
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}