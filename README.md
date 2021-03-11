# terraform-aws-vpc

This Terraform module creates a standardized secure AWS VPC

## Supported Resources

The follow resource are created:

- VPC
- Public Route Table
- Private Route Table
- 3 Public Subnets
- 3 Private Subnets
- NAT Security Group
- Bation Security Group
- Internet Gateway
- 2 Elastic IP's (Bastion, NAT)

## Motivation

Using a standard VPC configuration allows you to consistently create a secure and standard VPC that meets your defined compliance standards. We can ensure every VPC created is developed with security and scalabilty in mind.

## Supported Features

- Bastion Host
- Nat Instance

## Technology

- terraform >0.13
- AWS

## Requirements

- terraform >0.13
- AWS credentials configured i.g. AWS IAM user credentials, Gitlab runner/Jenkins Build server with IAM role and appropraite permissions
- 2 AWS Keypairs: Must be created prior to deployment
  - Bastion Key
  - Nat Key

## Usage

To use the module follow the code snippets below and referenced variables

### Standard VPC Deployment

main.tf

```hcl
module "vpc" {
  source               = "github.com/joeterlecki/terraform-aws-vpc-standard.git?ref=v1.3.4"
  vpc_cidr_block       = var.vpc_cidr_block
  vpc_name             = var.vpc_name
  environment          = var.environment
  subnet_cidrs         = var.subnet_cidrs
  nat_instance_key     = var.nat_instance_key
  bastion_instance_key = var.bastion_instance_key
  tags = var.tags
}
```

terraform.tfvars

```hcl
vpc_cidr_block = "10.0.0.0/20"
vpc_name       = "main-standard"
environment    = "prd"
subnet_cidrs = {
  "public_cidr_1"  = "10.0.1.0/24"
  "public_cidr_2"  = "10.0.3.0/24"
  "public_cidr_3"  = "10.0.5.0/24"
  "private_cidr_1" = "10.0.2.0/24"
  "private_cidr_2" = "10.0.4.0/24"
  "private_cidr_3" = "10.0.6.0/24"
}
nat_instance_key     = "nat-key"
bastion_instance_key = "bastion-key"
```

## Variables

| Name                 | Description                                                       | Type          | Default                | Required |
| -------------------- | ----------------------------------------------------------------- | ------------- | ---------------------- | -------- |
| vpc_cidr_block       | CIDR Block for the VPC                                            | string        | 10.0.0.0/20            | yes      |
| vpc_name             | The NAME of the VPC                                               | string        | devinitly-standard-vpc | yes      |
| environment          | The defining environment of the Account: DEV, TST, STG, PRD, ROOT | string        | dev                    | yes      |
| subnet_cidrs         | Desired CIDRs for public and private subnets                      | map           | See Variables File     | yes      |
| nat_instance_key     | The desired key pair name for the nat instance                    | string        | null                   | yes      |
| bastion_instance_key | The desired key pair name for the bastion instance                | string        | null                   | yes      |
| tags                 | Additional tags for resources                                     | map (string ) | null                   | no       |

## Outputs

| Name                           | Description                                                                                                                                             |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| vpc_arn                        | The Amazon Resource Name (ARN) of VPC                                                                                                                   |
| vpc_id                         | The ID of the VPC                                                                                                                                       |
| vpc_cidr_block                 | The CIDR block of the VPC                                                                                                                               |
| vpc_main_route_table_id        | The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association |
| vpc_default_network_acl_id     | The ID of the network ACL created by default on VPC creation                                                                                            |
| vpc_default_security_group_id  | The ID of the security group created by default on VPC creation                                                                                         |
| vpc_default_route_table_id     | The ID of the route table created by default on VPC creation                                                                                            |
| vpc_owner_id                   | The ID of the AWS account that owns the VPC                                                                                                             |
| aws_subnet_public_1_arn        | The ARN of the subnet                                                                                                                                   |
| aws_subnet_public_2_arn        | The ARN of the subnet                                                                                                                                   |
| aws_subnet_public_3_arn        | The ARN of the subnet                                                                                                                                   |
| aws_subnet_private_1_arn       | The ARN of the subnet                                                                                                                                   |
| aws_subnet_private_2_arn       | The ARN of the subnet                                                                                                                                   |
| aws_subnet_private_3_arn       | The ARN of the subnet                                                                                                                                   |
| aws_subnet_public_1_id         | The ID of the subnet                                                                                                                                    |
| aws_subnet_public_2_id         | The ID of the subnet                                                                                                                                    |
| aws_subnet_public_3_id         | The ID of the subnet                                                                                                                                    |
| aws_subnet_private_1_id        | The ID of the subnet                                                                                                                                    |
| aws_subnet_private_2_id        | The ID of the subnet                                                                                                                                    |
| aws_subnet_private_3_id        | The ID of the subnet                                                                                                                                    |
| nat_instance_id                | The AWS Instance ID of the NAT Instance                                                                                                                 |
| nat_instance_arn               | The ARN of the NAT instance                                                                                                                             |
| nat_security_group_id          | The id of the NAT security group                                                                                                                        |
| bastion_instance_id            | The AWS bastion ID of the NAT Instance                                                                                                                  |
| bastion_instance_arn           | The ARN of the bastion instance                                                                                                                         |
| bastion_security_group_id      | The id of the bastion security group                                                                                                                    |
| aws_internet_gateway_id        | The ID of the Internet Gateway                                                                                                                          |
| private_route_table_id         | The ID of the private route table                                                                                                                       |
| public_route_table_id          | The ID of the public route table                                                                                                                        |
| bastion_instance_id            | The AWS Instance ID of the Bastion Instance                                                                                                             |
| s3_vpc_endpoint_id             | The ID of the VPC endpoint                                                                                                                              |
| s3_vpc_endpoint_prefix_list_id | The prefix list for gateway vpc s3 endpoint                                                                                                             |
