output "vpc_arn" {
  description = "The Amazon Resource Name (ARN) of VPC"
  value       = aws_vpc.standard_vpc.arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.standard_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.standard_vpc.cidr_block
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association"
  value       = aws_vpc.standard_vpc.main_route_table_id
}

output "vpc_default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.standard_vpc.default_network_acl_id
}

output "vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.standard_vpc.default_security_group_id
}

output "vpc_default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = aws_vpc.standard_vpc.default_route_table_id
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = aws_vpc.standard_vpc.owner_id
}

output "aws_subnet_public_1_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.public_subnet_1.arn
}

output "aws_subnet_public_2_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.public_subnet_2.arn
}

output "aws_subnet_public_3_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.public_subnet_3.arn
}

output "aws_subnet_private_1_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.private_subnet_1.arn
}

output "aws_subnet_private_2_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.private_subnet_2.arn
}

output "aws_subnet_private_3_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.private_subnet_3.arn
}

output "aws_subnet_public_1_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.public_subnet_1.id
}

output "aws_subnet_public_2_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.public_subnet_2.id
}

output "aws_subnet_public_3_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.public_subnet_3.id
}

output "aws_subnet_private_1_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.private_subnet_1.id
}

output "aws_subnet_private_2_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.private_subnet_2.id
}

output "aws_subnet_private_3_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.private_subnet_3.id
}

output "aws_internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gateway.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private_route_table.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_route_table.id
}

output "nat_instance_id" {
  description = "The AWS Instance ID of the NAT Instance"
  value       = aws_instance.nat_instance.id
}

output "nat_instance_arn" {
  description = "The ARN of the NAT instance"
  value       = aws_instance.nat_instance.arn
}

output "nat_security_group_id" {
  description = "The id of the NAT security group"
  value       = aws_security_group.nat_security_group.id
}

output "nat_security_group_arn" {
  description = "The ARN of the NAT security group"
  value       = aws_security_group.nat_security_group.arn
}

output "bastion_instance_id" {
  description = "The AWS Instance ID of the Bastion Instance"
  value       = aws_instance.bastion_instance.id
}

output "bastion_instance_arn" {
  description = "The ARN of the Bastion instance"
  value       = aws_instance.bastion_instance.arn
}

output "s3_vpc_endpoint_id" {
  description = "The ID of the VPC endpoint"
  value       = aws_vpc_endpoint.s3_vpc_endpoint.id
}

output "s3_vpc_endpoint_prefix_list_id" {
  description = "The prefix list for gateway vpc s3 endpoint"
  value = aws_vpc_endpoint.s3_vpc_endpoint.prefix_list_id
}