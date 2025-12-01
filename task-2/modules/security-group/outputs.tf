output "security_group_id" {
  value = aws_security_group.main.id
}

output "vpc_endpoints_security_group_id" {
  value = aws_security_group.vpc_endpoints.id
}

output "ssm_endpoint_id" {
  value = aws_vpc_endpoint.ssm.id
}

output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}
