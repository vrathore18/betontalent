output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_elastic_ip" {
  description = "Elastic IP address of the EC2 instance (if assigned)"
  value       = module.ec2.elastic_ip
}

output "ec2_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = module.ec2.private_dns
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2.public_dns
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "rds_address" {
  description = "The hostname of the RDS instance"
  value       = module.rds.db_instance_address
}

output "rds_port" {
  description = "The port of the RDS instance"
  value       = module.rds.db_instance_port
}

output "rds_database_name" {
  description = "The name of the database"
  value       = module.rds.db_name
}

output "rds_instance_id" {
  description = "The RDS instance ID"
  value       = module.rds.db_instance_id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = module.security_groups.ec2_security_group_id
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = module.security_groups.rds_security_group_id
}

output "environment" {
  description = "The deployment environment"
  value       = var.environment
}

output "workspace" {
  description = "The Terraform workspace"
  value       = terraform.workspace
}
