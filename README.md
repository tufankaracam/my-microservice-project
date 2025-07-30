# RDS Terraform Module

Universal Terraform module for creating AWS RDS Instance or Aurora Cluster.

## Usage Example

```hcl
module "rds" {
  source = "./modules/rds"
  
  name       = "myapp-db"
  use_aurora = false  # true for Aurora Cluster
  
  # RDS settings
  engine         = "postgres"
  engine_version = "17.2"
  parameter_group_family_rds = "postgres17"
  
  # Aurora settings (when use_aurora = true)
  engine_cluster = "aurora-postgresql"
  engine_version_cluster = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  
  # Common settings
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  db_name          = "myapp"
  username         = "postgres"
  password         = "securepassword123"
  
  vpc_id             = module.vpc.vpc_id
  subnet_private_ids = module.vpc.private_subnets
  subnet_public_ids  = module.vpc.public_subnets
  
  multi_az                = true
  backup_retention_period = 7
  
  parameters = {
    max_connections = "200"
  }
  
  tags = {
    Environment = "dev"
  }
}
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | - | Database instance name |
| `use_aurora` | bool | false | Use Aurora cluster instead of RDS |
| `engine` | string | "postgres" | RDS database engine |
| `engine_version` | string | "17.2" | RDS database version |
| `engine_cluster` | string | "aurora-postgresql" | Aurora engine type |
| `engine_version_cluster` | string | "15.3" | Aurora version |
| `parameter_group_family_rds` | string | "postgres17" | RDS parameter group family |
| `parameter_group_family_aurora` | string | "aurora-postgresql15" | Aurora parameter group family |
| `instance_class` | string | "db.t3.micro" | Database instance class |
| `allocated_storage` | number | 20 | Storage size in GB (RDS only) |
| `db_name` | string | - | Database name |
| `username` | string | "postgres" | Master username |
| `password` | string | - | Master password |
| `vpc_id` | string | - | VPC ID |
| `subnet_private_ids` | list(string) | - | Private subnet IDs |
| `subnet_public_ids` | list(string) | - | Public subnet IDs |
| `publicly_accessible` | bool | false | Enable public access |
| `multi_az` | bool | false | Enable Multi-AZ (RDS only) |
| `backup_retention_period` | number | 7 | Backup retention in days |
| `aurora_replica_count` | number | 1 | Number of Aurora read replicas |
| `parameters` | map(string) | {} | Custom database parameters |
| `tags` | map(string) | {} | Resource tags |

## Configuration Changes

**Change database engine:**
```hcl
# PostgreSQL to MySQL
engine = "mysql"
engine_version = "8.0.35"
parameter_group_family_rds = "mysql8.0"
```

**Change instance class:**
```hcl
instance_class = "db.t3.micro"    # Development
instance_class = "db.t3.medium"   # Production
instance_class = "db.r6g.large"   # High performance
```

**Add custom parameters:**
```hcl
parameters = {
  max_connections = "500"
  log_statement = "all"
}
```

## Terraform Commands

```bash
# Initialize the module
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply

# Get outputs
terraform output

# Destroy resources (when needed)
terraform destroy
```