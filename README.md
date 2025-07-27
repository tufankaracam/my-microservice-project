# Lesson-7: Kubernetes + Helm Project

## Overview
Django application deployment on AWS EKS using Terraform and Helm.

## Architecture
- **EKS Cluster**: Managed Kubernetes on AWS
- **ECR**: Docker image registry
- **Helm Chart**: Django app with auto-scaling

## Quick Setup

### 1. Infrastructure
```bash
terraform init
terraform apply
```

### 2. Docker Image
```bash
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.eu-central-1.amazonaws.com
docker build -t lesson-7-ecr .
docker tag lesson-7-ecr:latest <account-id>.dkr.ecr.eu-central-1.amazonaws.com/lesson-7-ecr:latest
docker push <account-id>.dkr.ecr.eu-central-1.amazonaws.com/lesson-7-ecr:latest
```

### 3. Kubernetes Setup
```bash
aws eks --region eu-central-1 update-kubeconfig --name lesson-7-eks
helm install django-app ./charts/django-app
```

## Verification
```bash
kubectl get pods          # 2 Django pods running
kubectl get svc           # LoadBalancer with External IP
kubectl get hpa           # Auto-scaling 2-6 pods at 70% CPU
kubectl get configmap     # Environment variables
```

## Project Structure
```
lesson-7/
├── main.tf
├── modules/
│   ├── vpc/
│   ├── ecr/
│   └── eks/
└── charts/django-app/
    ├── Chart.yaml
    ├── values.yaml
    └── templates/
```

## Access
- **External URL**: `kubectl get svc django-app-django`
- **Port**: 80

## Components
- **Terraform**: EKS + ECR + VPC modules
- **Helm**: Deployment + Service + ConfigMap + HPA
- **Docker**: Django application image
- **Kubernetes**: Container orchestration