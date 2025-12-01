# AWS Cloud Security Infrastructure

This Terraform project creates a secure AWS infrastructure following security best practices and the principle of least privilege.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                    VPC                                       │
│                              (10.0.0.0/16)                                   │
│                                                                              │
│   ┌──────────────────────┐           ┌──────────────────────┐               │
│   │    Public Subnet     │           │    Public Subnet     │               │
│   │    (10.0.1.0/24)     │           │    (10.0.2.0/24)     │               │
│   │                      │           │                      │               │
│   │   ┌──────────────┐   │           │                      │               │
│   │   │ NAT Gateway  │   │           │                      │               │
│   │   └──────────────┘   │           │                      │               │
│   └──────────────────────┘           └──────────────────────┘               │
│              │                                                               │
│              ▼                                                               │
│   ┌──────────────────────┐           ┌──────────────────────┐               │
│   │    Private Subnet    │           │    Private Subnet    │               │
│   │    (10.0.10.0/24)    │           │    (10.0.20.0/24)    │               │
│   │                      │           │                      │               │
│   │   ┌──────────────┐   │           │                      │               │
│   │   │     EC2      │   │           │                      │               │
│   │   │  Instance    │   │           │                      │               │
│   │   └──────────────┘   │           │                      │               │
│   │                      │           │                      │               │
│   │   VPC Endpoints:     │           │                      │               │
│   │   - SSM              │           │                      │               │
│   │   - S3               │           │                      │               │
│   │   - KMS              │           │                      │               │
│   │   - Secrets Manager  │           │                      │               │
│   │   - CloudWatch Logs  │           │                      │               │
│   └──────────────────────┘           └──────────────────────┘               │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Features

### Core Requirements
- **VPC with Public/Private Subnets**: Multi-AZ deployment with NAT Gateway
- **EC2 Instance in Private Subnet**: Secure instance with no direct internet access
- **Security Groups**: Least privilege network access controls
- **IAM Roles**: Minimal permissions for EC2 instances
- **CloudTrail**: API logging with S3 storage and CloudWatch integration
- **Encryption**: KMS encryption for EBS, S3, CloudWatch Logs, and more

### Bonus Features
- **AWS Config**: Compliance monitoring with 10 security rules
- **CloudWatch Alarms**: 10 security alarms for unauthorized actions
- **Secrets Manager**: Secure storage for credentials and API keys

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- AWS account with sufficient permissions

## Deployment Instructions

### 1. Clone and Configure

```bash
# Navigate to the project directory
cd task-2

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit the variables file with your settings
vim terraform.tfvars
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply the Configuration

```bash
terraform apply
```

### 5. Access the EC2 Instance

Since the EC2 instance is in a private subnet with no SSH access by default, use AWS Systems Manager Session Manager:

```bash
# Using AWS CLI
aws ssm start-session --target <instance-id>

# Or use the AWS Console
# Navigate to: EC2 > Instances > Select Instance > Connect > Session Manager
```

## Security Best Practices Implemented

### Network Security
1. **VPC Flow Logs**: All network traffic is logged to CloudWatch
2. **Private Subnets**: EC2 instances have no direct internet access
3. **NAT Gateway**: Controlled outbound internet access
4. **VPC Endpoints**: Private connectivity to AWS services
5. **Network ACLs**: Additional layer of network security
6. **Security Groups**: Least privilege port access

### Identity & Access Management
1. **IAM Roles**: EC2 uses IAM roles instead of access keys
2. **Least Privilege**: Minimal permissions for each service
3. **No Root Access**: Root account usage triggers alerts
4. **SSM Session Manager**: No SSH keys required

### Data Protection
1. **KMS Encryption**: All data encrypted at rest
   - EBS volumes
   - S3 buckets
   - CloudWatch Logs
   - SNS topics
   - Secrets Manager
2. **Key Rotation**: KMS keys rotate automatically
3. **Secrets Manager**: Secure credential storage

### Logging & Monitoring
1. **CloudTrail**: All API calls logged
2. **CloudWatch Logs**: Centralized log management
3. **CloudTrail Insights**: Anomaly detection
4. **Log File Validation**: Data integrity verification

### Compliance & Governance
1. **AWS Config**: Continuous compliance monitoring
2. **Config Rules**: 10 security compliance checks
3. **CloudWatch Alarms**: Real-time security alerts
4. **S3 Bucket Policies**: Deny insecure transport

### EC2 Security
1. **IMDSv2 Required**: Protection against SSRF attacks
2. **Detailed Monitoring**: Enhanced instance monitoring
3. **Encrypted Volumes**: All EBS volumes encrypted
4. **Automatic Updates**: Security patches applied automatically
5. **SSH Disabled by Default**: Use SSM instead

## AWS Config Rules

| Rule | Description |
|------|-------------|
| EBS Encryption Check | Ensures EBS volumes are encrypted |
| S3 Public Access Check | Ensures S3 buckets block public access |
| S3 Encryption Check | Ensures S3 buckets have encryption enabled |
| EC2 IMDSv2 Check | Ensures EC2 instances use IMDSv2 |
| VPC Flow Logs Check | Ensures VPC Flow Logs are enabled |
| CloudTrail Enabled Check | Ensures CloudTrail is enabled |
| Root MFA Check | Ensures root account has MFA enabled |
| IAM User MFA Check | Ensures IAM users have MFA enabled |
| IAM Credentials Unused Check | Detects unused IAM credentials |
| SSH Restricted Check | Ensures security groups don't allow unrestricted SSH |

## CloudWatch Security Alarms

| Alarm | Description |
|-------|-------------|
| Root Account Usage | Alerts when root account is used |
| Unauthorized API Calls | Alerts on access denied errors |
| IAM Policy Changes | Alerts on IAM policy modifications |
| Security Group Changes | Alerts on security group changes |
| NACL Changes | Alerts on Network ACL changes |
| Console Sign-In Failures | Alerts on failed login attempts |
| CloudTrail Changes | Alerts on CloudTrail configuration changes |
| VPC Changes | Alerts on VPC configuration changes |
| KMS Key Changes | Alerts on KMS key disabling/deletion |
| S3 Bucket Policy Changes | Alerts on S3 policy changes |

## Assumptions and Design Choices

### Assumptions
1. Single region deployment (us-east-1 by default)
2. Two availability zones for high availability
3. No need for public-facing services
4. SSM Session Manager is preferred over SSH

### Design Choices
1. **Modular Architecture**: Each component is a reusable module
2. **Defense in Depth**: Multiple layers of security controls
3. **Encryption by Default**: All data encrypted at rest
4. **Logging Everywhere**: Comprehensive audit trail
5. **No SSH Keys**: Using SSM reduces attack surface
6. **VPC Endpoints**: Keeps traffic within AWS network
7. **Separate KMS Keys**: Different keys for different purposes

## Cost Considerations

Main cost drivers:
- NAT Gateway (hourly + data transfer)
- VPC Endpoints (hourly + data transfer)
- CloudTrail (data events logging)
- AWS Config (configuration items recorded)
- KMS (key usage)

To reduce costs in non-production environments:
- Set `enable_aws_config = false`
- Consider removing some VPC endpoints

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note**: S3 buckets have `force_destroy = false` by default. To destroy, either:
- Empty the buckets manually first
- Set `force_destroy = true` in the module calls

## Module Structure

```
task-2/
├── main.tf                    # Main configuration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── versions.tf                # Provider requirements
├── terraform.tfvars.example   # Example variables
├── README.md                  # This file
└── modules/
    ├── vpc/                   # VPC, subnets, NAT, flow logs
    ├── security-group/        # Security groups, VPC endpoints
    ├── iam/                   # IAM roles and policies
    ├── ec2/                   # EC2 instance
    ├── kms/                   # KMS keys
    ├── cloudtrail/            # CloudTrail and S3 bucket
    ├── aws-config/            # AWS Config and rules
    ├── cloudwatch/            # CloudWatch alarms
    └── secrets-manager/       # Secrets Manager secrets
```

## Future Enhancements

1. Add AWS GuardDuty for threat detection
2. Implement AWS Security Hub for centralized security view
3. Add AWS WAF for web application firewall
4. Implement AWS Backup for automated backups
5. Add AWS Inspector for vulnerability scanning
6. Implement cross-region replication for DR

## License

This project is provided as-is for educational purposes.
