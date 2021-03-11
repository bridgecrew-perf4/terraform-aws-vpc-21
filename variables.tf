variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/20"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "devinitly-standard-vpc"
}

variable "environment" {
  description = "The defining environment of the Account: DEV, TST, STG, PRD, ROOT"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet_cidrs" {
  type = map
  default = {
    "public_cidr_1"  = "10.0.1.0/27"
    "public_cidr_2"  = "10.0.3.0/27"
    "public_cidr_3"  = "10.0.5.0/27"
    "private_cidr_1" = "10.0.2.0/27"
    "private_cidr_2" = "10.0.4.0/27"
    "private_cidr_3" = "10.0.6.0/27"
  }
}

variable "nat_instance_key" {
  type        = string
  description = "The desired key pair name for the nat instance"
  default     = null
}

variable "bastion_instance_key" {
  type        = string
  description = "The desired key pair name for the bastion instance"
  default     = null
}

locals {
  tags = merge(
    var.tags,
    {
      Environment  = var.environment
      VPC          = var.vpc_name
      Provisioning = "terraform"
    },
  )
}
