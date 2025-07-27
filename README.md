# CI/CD Pipeline with Jenkins, Terraform, Helm, and Argo CD

## Project Overview

This project implements a complete CI/CD pipeline using modern DevOps tools:
- **Jenkins** for continuous integration and deployment
- **Terraform** for infrastructure as code
- **Helm** for Kubernetes package management
- **Argo CD** for GitOps continuous deployment
- **AWS EKS** for Kubernetes cluster
- **AWS ECR** for container registry

## Architecture

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Developer │───▶│   GitHub    │───▶│   Jenkins   │───▶│     ECR     │
│             │    │             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                            │                                     │
                            ▼                                     ▼
                   ┌─────────────┐                      ┌─────────────┐
                   │   Argo CD   │◀─────────────────────│     EKS     │
                   │             │                      │  Cluster    │
                   └─────────────┘                      └─────────────┘
```

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- kubectl installed
- Git repository with necessary permissions

## Infrastructure Setup

### 1. Terraform Deployment

```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply
```

### 2. Infrastructure Components

The Terraform configuration creates:
- **VPC** with public/private subnets
- **EKS Cluster** with worker nodes
- **ECR Repository** for Docker images
- **Jenkins** deployed via Helm
- **Argo CD** deployed via Helm
- **IAM Roles** and policies

## Jenkins Configuration

### Accessing Jenkins

1. Get Jenkins LoadBalancer URL:
```bash
kubectl get svc jenkins -n jenkins
```

2. Get admin password:
```bash
kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

3. Access Jenkins UI:
   - URL: `http://JENKINS_LOAD_BALANCER_URL:8080`
   - Username: `admin`
   - Password: (from step 2)

### Jenkins Pipeline

The pipeline (`goit-django-docker`) performs:

1. **Build Stage**: Uses Kaniko to build Docker image from Dockerfile
2. **Push Stage**: Pushes image to AWS ECR with versioned tags
3. **Update Stage**: Updates Helm chart values.yaml with new image tag
4. **Git Stage**: Commits and pushes changes back to repository

### Running Jenkins Job

1. Navigate to Jenkins dashboard
2. Click on `goit-django-docker` job
3. Click **"Build Now"**
4. Monitor progress in **"Console Output"**

## Argo CD Configuration

### Accessing Argo CD

1. Get Argo CD admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

2. Port forward to access UI:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

3. Access Argo CD UI:
   - URL: `https://localhost:8080`
   - Username: `admin`
   - Password: (from step 1)

### Argo CD Application

The `django-app` application:
- **Source**: GitHub repository (`lesson-8-9/charts/django-app`)
- **Destination**: EKS cluster (`default` namespace)
- **Sync Policy**: Automatic with pruning enabled
- **Health**: Monitors deployment, service, and pod health

### Verifying Deployment

1. Check application status in Argo CD UI
2. Verify pods are running:
```bash
kubectl get pods -n default
```

3. Check application logs:
```bash
kubectl logs -l app=django-app -n default
```

## CI/CD Workflow

### Complete Flow

1. **Developer** pushes code changes to GitHub
2. **Jenkins** automatically triggers pipeline:
   - Builds Docker image using Kaniko
   - Pushes to ECR with tag `v1.0.${BUILD_NUMBER}`
   - Updates `charts/django-app/values.yaml` with new tag
   - Commits changes back to Git
3. **Argo CD** detects Git changes:
   - Syncs new Helm chart
   - Deploys updated application to Kubernetes
   - Monitors health and status

### Testing the Pipeline

1. Make a code change in the Django application
2. Commit and push to `lesson-8-9` branch
3. Trigger Jenkins job manually or wait for webhook
4. Monitor Jenkins build progress
5. Check Argo CD for automatic synchronization
6. Verify new pods are deployed with updated image

## Troubleshooting

### Common Issues

**Jenkins Pod Stuck in Pending**
```bash
kubectl describe pod jenkins-0 -n jenkins
# Check for PVC/storage issues
```

**Argo CD Repository Authentication**
- Ensure repository is public or credentials are configured
- Add repository in Argo CD Settings > Repositories

**Image Pull Errors**
```bash
# Check ECR authentication
aws ecr get-login-password --region eu-central-1
```

**Git Conflicts**
```bash
# Resolve divergent branches
git config pull.rebase false
git pull origin lesson-8-9
```

## Resource Management

### Cleanup

⚠️ **Important**: Always clean up resources to avoid charges

```bash
# Destroy all infrastructure
terraform destroy

# Confirm deletion of S3 backend resources if needed
```

### Cost Optimization

- EKS cluster runs on `t3.medium` instances
- Minimum 1, maximum 2 nodes for cost efficiency
- Resources can be scaled down when not in use

## Technologies Used

- **Terraform** - Infrastructure as Code
- **AWS EKS** - Kubernetes service
- **AWS ECR** - Container registry
- **Jenkins** - CI/CD automation
- **Helm** - Kubernetes package manager
- **Argo CD** - GitOps deployment
- **Kaniko** - Container image building
- **Django** - Sample application

## Project Structure

```
project/
├── main.tf                          # Main Terraform configuration
├── backend.tf                       # S3 backend configuration
├── modules/
│   ├── vpc/                        # VPC module
│   ├── eks/                        # EKS cluster module
│   ├── ecr/                        # ECR repository module
│   ├── jenkins/                    # Jenkins Helm deployment
│   └── argo_cd/                    # Argo CD Helm deployment
├── docker/
│   └── Dockerfile                  # Application container
├── lesson-8-9/charts/django-app/   # Helm chart
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
└── Jenkinsfile                     # Pipeline definition
```


---