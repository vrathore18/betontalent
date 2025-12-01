# AWS Infrastructure with Terraform

This Terraform configuration deploys a complete AWS infrastructure including VPC, EC2, and RDS with security groups and remote state management.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                          VPC                                 │
│  ┌─────────────────────┐    ┌─────────────────────┐        │
│  │   Public Subnet 1   │    │   Public Subnet 2   │        │
│  │   (AZ-a)           │    │   (AZ-b)           │        │
│  │   ┌─────────┐      │    │                     │        │
│  │   │   EC2   │      │    │                     │        │
│  │   └─────────┘      │    │                     │        │
│  └────────┬────────────┘    └─────────────────────┘        │
│           │                                                  │
│  ┌────────▼────────────┐    ┌─────────────────────┐        │
│  │  Private Subnet 1   │    │  Private Subnet 2   │        │
│  │   (AZ-a)           │    │   (AZ-b)           │        │
│  │   ┌─────────┐      │    │   ┌─────────┐      │        │
│  │   │   RDS   │◄─────┼────┼───┤   RDS   │      │        │
│  │   │(Primary)│      │    │   │(Standby)│      │        │
│  │   └─────────┘      │    │   └─────────┘      │        │
│  └─────────────────────┘    └─────────────────────┘        │
│                                        (Multi-AZ)           │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create VPC, EC2, RDS, and related resources

## Module Structure

```
task-1/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
├── terraform.tfvars.example
├── environments/
│   ├── staging.tfvars
│   └── production.tfvars
└── modules/
    ├── vpc/
    ├── ec2/
    ├── rds/
    └── security-groups/
```

## Quick Start

```bash
cd task-1
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Using Terraform Workspaces

```bash
terraform workspace new staging
terraform workspace new production
terraform workspace select staging
terraform apply -var-file=environments/staging.tfvars
```

## Remote State Configuration

To enable remote state with S3 and DynamoDB locking:

1. Create S3 bucket and DynamoDB table
2. Uncomment the backend block in `main.tf`
3. Run `terraform init -migrate-state`

## Environment Defaults

| Setting | Staging | Production |
|---------|---------|------------|
| EC2 Instance Type | t3.micro | t3.small |
| RDS Instance Class | db.t3.micro | db.t3.small |
| RDS Multi-AZ | false | true |
| NAT Gateway | false | true |

## Security

- SSH access disabled by default
- RDS in private subnets, accessible only from EC2
- Encrypted volumes and storage
- Set credentials via environment variables:

```bash
export TF_VAR_rds_master_username="admin"
export TF_VAR_rds_master_password="your-secure-password"
```

## Cleanup

```bash
terraform workspace select staging
terraform destroy -var-file=environments/staging.tfvars
```
