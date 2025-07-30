# 🚀 Final DevOps Project - AWS EKS with Complete CI/CD Pipeline

This project aims to build a complete DevOps infrastructure on AWS using **Terraform**. It provides a production-ready environment including Kubernetes (EKS), CI/CD pipelines, and monitoring systems.

## 📋 Table of Contents

- [Project Architecture](#-project-architecture)
- [Technology Stack](#-technology-stack)
- [Installation Steps](#-installation-steps)
- [Service Access Information](#-service-access-information)
- [Monitoring](#-monitoring)
- [Troubleshooting](#-troubleshooting)
- [Cleanup](#-cleanup)

## 🏗️ Project Architecture

```
AWS Cloud
├── VPC (10.0.0.0/16)
│   ├── Public Subnets (3 AZ)
│   └── Private Subnets (3 AZ)
├── EKS Cluster
│   ├── Worker Nodes (t3.large)
│   ├── Jenkins (CI/CD)
│   ├── ArgoCD (GitOps)
│   ├── Prometheus (Metrics)
│   └── Grafana (Dashboards)
├── RDS PostgreSQL
├── ECR Repository
└── S3 + DynamoDB (Terraform State)
```

## 🛠️ Technology Stack

### Infrastructure as Code
- **Terraform** - Infrastructure provisioning
- **AWS Provider** - Cloud resources
- **Helm** - Kubernetes package management

### Container Orchestration
- **Amazon EKS** - Managed Kubernetes
- **Docker** - Containerization
- **Amazon ECR** - Container registry

### CI/CD Pipeline
- **Jenkins** - Continuous Integration
- **ArgoCD** - GitOps Continuous Deployment
- **GitHub** - Source code management

### Database
- **Amazon RDS** - PostgreSQL database
- **Multi-AZ** deployment for high availability

### Monitoring & Observability
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Node Exporter** - System metrics
- **Kube State Metrics** - Kubernetes metrics

## 🚀 Installation Steps

### Prerequisites

1. **AWS CLI** installed and configured
2. **Terraform** v1.0+ installed
3. **kubectl** installed
4. **Helm** v3+ installed
5. **Git** installed

### 1. Clone the Repository

```bash
git clone <repository-url>
cd final-project
```

### 2. Initialize Terraform Backend

```bash
# Backend resources (S3 + DynamoDB)
terraform init
terraform apply -target=module.s3_backend
```

### 3. Backend Configuration

Create `backend.tf` file:

```hcl
terraform {
  backend "s3" {
    bucket         = "tk-terraform-state-lesson7-000001"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### 4. Deploy Infrastructure

```bash
# Reinitialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy infrastructure
terraform apply
```

### 5. Connect to Kubernetes Cluster

```bash
# Connect to EKS cluster
aws eks update-kubeconfig --region eu-central-1 --name lesson-7-eks

# Test connection
kubectl get nodes
```

### 6. Monitoring Setup

```bash
# Monitoring namespace
kubectl create namespace monitoring

# Prometheus installation
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus --namespace monitoring

# Grafana installation
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana --namespace monitoring --set adminPassword=admin123

# LoadBalancer services
kubectl patch service prometheus-server -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'
kubectl patch service grafana -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'
```

## 🌐 Service Access Information

### Getting External URLs

```bash
# Jenkins
kubectl get service jenkins -n jenkins

# ArgoCD
kubectl get service argocd-server -n argocd

# Prometheus
kubectl get service prometheus-server -n monitoring

# Grafana
kubectl get service grafana -n monitoring
```

### Default Credentials

#### Jenkins
- **URL**: `http://<jenkins-external-ip>`
- **User**: `admin`
- **Password**: 
  ```bash
  kubectl get secret jenkins -n jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
  ```

#### ArgoCD
- **URL**: `http://<argocd-external-ip>`
- **User**: `admin`
- **Password**:
  ```bash
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
  ```

#### Grafana
- **URL**: `http://<grafana-external-ip>`
- **User**: `admin`
- **Password**: `admin123`

#### RDS PostgreSQL
- **Endpoint**: Get from Terraform output
- **User**: `postgres`
- **Password**: `12,34,56,78!tk`
- **Database**: `tkdb`

## 📊 Monitoring

### Prometheus Targets

Prometheus collects metrics from:
- **Kubernetes API Server**
- **Node metrics** (CPU, Memory, Disk)
- **Pod metrics**
- **Application metrics**

### Grafana Dashboards

Recommended dashboards:
- **ID: 315** - Kubernetes Cluster Monitoring
- **ID: 1860** - Node Exporter Full
- **ID: 6417** - Kubernetes Cluster

#### Data Source Configuration

Prometheus data source in Grafana:
```
URL: http://prometheus-server.monitoring.svc:80
```

## 🔧 Troubleshooting

### Pods Stuck in Pending State

```bash
# Check node capacity
kubectl describe nodes

# Examine pod details
kubectl describe pod <pod-name> -n <namespace>
```

### LoadBalancer IP Not Assigned

```bash
# Check service status
kubectl describe service <service-name> -n <namespace>

# NodePort alternative
kubectl patch service <service-name> -n <namespace> -p '{"spec":{"type":"NodePort"}}'
```

### Prometheus Targets DOWN

```bash
# Check service discovery
kubectl get endpoints -n monitoring

# Check network policies
kubectl get networkpolicy --all-namespaces
```

## 🎯 Project Features

### ✅ Infrastructure
- [x] VPC with public/private subnets
- [x] EKS cluster with t3.large worker nodes
- [x] RDS PostgreSQL with Multi-AZ
- [x] ECR repository
- [x] S3 backend for Terraform state

### ✅ CI/CD Pipeline
- [x] Jenkins for continuous integration
- [x] ArgoCD for GitOps deployment
- [x] Automated Docker image builds
- [x] Kubernetes deployments

### ✅ Monitoring & Observability
- [x] Prometheus metrics collection
- [x] Grafana dashboards
- [x] Node and cluster monitoring
- [x] Application performance metrics

### ✅ Security
- [x] VPC network isolation
- [x] IAM roles and policies
- [x] Security groups
- [x] Encrypted storage

## 📈 Resource Specifications

### EKS Cluster
- **Instance Type**: t3.large
- **Node Count**: 2 (min: 1, max: 3)
- **Pod Capacity**: 35 per node
- **Kubernetes Version**: Latest stable

### RDS Database
- **Engine**: PostgreSQL 17.2
- **Instance Class**: db.t3.medium
- **Storage**: 20GB GP2
- **Backup**: 7 days retention
- **Multi-AZ**: Enabled

## 🧹 Cleanup

⚠️ **WARNING**: This command will delete all resources!

```bash
# Delete Helm releases
helm uninstall prometheus -n monitoring
helm uninstall grafana -n monitoring

# Destroy infrastructure with Terraform
terraform destroy
```

## 📝 Notes

- **Persistent Volume**: Persistence disabled for monitoring (development environment)
- **LoadBalancer**: AWS Application Load Balancer created automatically
- **Costs**: Make sure to delete unused resources
- **Backup**: Terraform state stored securely in S3