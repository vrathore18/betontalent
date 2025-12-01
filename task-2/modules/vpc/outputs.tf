output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "flow_log_group_name" {
  value = var.enable_flow_logs ? aws_cloudwatch_log_group.flow_log[0].name : null
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "private_route_table_ids" {
  value = [aws_route_table.private.id]
}
