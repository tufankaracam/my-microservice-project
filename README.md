# CI/CD Pipeline - Lesson 8-9

Complete CI/CD pipeline using Jenkins, Terraform, Helm, and Argo CD.

## Quick Start

### 1. Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### 2. Access Jenkins
```bash
# Get Jenkins URL
kubectl get svc jenkins -n jenkins

# Get admin password
kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

Access: `http://JENKINS_URL:8080` (admin/password)

### 3. Run Jenkins Job
1. Open Jenkins UI
2. Click `goit-django-docker` job
3. Click **Build Now**
4. Monitor in Console Output

### 4. Access Argo CD
```bash
# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access: `https://localhost:8080` (admin/password)

### 5. Verify Deployment
```bash
kubectl get pods -n default
kubectl get applications -n argocd
```

## Architecture

**Flow**: Code → GitHub → Jenkins → ECR → Git Update → Argo CD → Kubernetes

## Components

- **AWS EKS**: Kubernetes cluster
- **AWS ECR**: Container registry  
- **Jenkins**: CI pipeline (build, push, update)
- **Argo CD**: GitOps deployment
- **Helm**: Package management

## Troubleshooting

**Jenkins Pending**: Check PVC/storage issues
**Argo CD Auth**: Add repository in Settings > Repositories
**Git Conflicts**: `git pull --rebase`

## Cleanup
```bash
terraform destroy
```

---
**Result**: Full automated CI/CD pipeline with GitOps deployment!