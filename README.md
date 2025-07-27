# Lesson-5 Terraform Infrastructure Project

## Overview
This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy a modular AWS infrastructure including S3 backend, VPC networking, and ECR container registry.

## Project Structure
lesson-5/
│
├── main.tf                  # Main file for connecting modules
├── backend.tf               # Backend configuration for state (S3 + DynamoDB)
├── outputs.tf               # Global resource outputs
├── modules/                 # Directory with all modules
│   │
│   ├── s3-backend/          # Module for S3 and DynamoDB
│   │   ├── s3.tf            # S3 bucket creation
│   │   ├── dynamodb.tf      # DynamoDB creation
│   │   ├── variables.tf     # Variables for S3 backend
│   │   └── outputs.tf       # S3 and DynamoDB outputs
│   │
│   ├── vpc/                 # Module for VPC
│   │   ├── vpc.tf           # VPC, subnets, Internet Gateway creation
│   │   ├── routes.tf        # Routing configuration
│   │   ├── variables.tf     # VPC variables
│   │   └── outputs.tf       # VPC information outputs
│   │
│   └── ecr/                 # Module for ECR
│       ├── ecr.tf           # ECR repository creation
│       ├── variables.tf     # ECR variables
│       └── outputs.tf       # ECR repository URL output
│
└── README.md                # Project documentation


## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (version ~> 5.0)
- AWS account with necessary permissions

## Deployment Commands

### Initial Setup
```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply
```