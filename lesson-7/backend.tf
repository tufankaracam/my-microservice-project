terraform {
  backend "s3" {
    bucket         = "tk-terraform-state-lesson7-000001"
    key            = "lesson-7/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}