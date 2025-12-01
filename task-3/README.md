# Terraform Lambda + S3 Project

Simple AWS Lambda function with S3 bucket storage.

## Setup

1. Clone this repo
2. Run `terraform init`
3. Run `terraform apply`

## What was fixed

### 1. S3 Bucket ACL issue

The original code had `acl = "private"` directly in the bucket resource which is deprecated in AWS provider v4+.

Fixed by adding separate resources:
- `aws_s3_bucket_ownership_controls`
- `aws_s3_bucket_acl`

### 2. Missing IAM permissions

Lambda role didn't have any S3 permissions. Added IAM policy with:
- s3:GetObject
- s3:PutObject
- s3:DeleteObject
- s3:ListBucket

## Resources

- S3 bucket for storing data
- Lambda function (Python 3.8)
- IAM role with S3 access

## Test

```bash
terraform init
terraform validate
terraform plan
terraform apply
```