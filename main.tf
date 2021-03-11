//TO DO

// TODO nat secgroup allow ecs in bound 443

// ECS INTO ITS OWN STATE ANF FOLDER FOR COMPUTE EC2
// create ecs service and pieces
// ecs secgroup outbound 443 to nat
// ecs sec group out to vpc cidr block
// ecs sec grooup out bound to vpce s3 prefix list

data "aws_ami" "amazon_2_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

data "aws_ebs_default_kms_key" "default_ebs" {}

resource "aws_ebs_encryption_by_default" "ebs_encryption" {
  enabled = true
}

resource "aws_vpc" "standard_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge({ Name = var.vpc_name }, local.tags)

}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.standard_vpc.id
  cidr_block              = var.subnet_cidrs["public_cidr_1"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = merge({ Name = "public-${var.subnet_cidrs["public_cidr_1"]}" }, local.tags)
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.standard_vpc.id
  cidr_block              = var.subnet_cidrs["public_cidr_2"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = merge({ Name = "public-${var.subnet_cidrs["public_cidr_2"]}" }, local.tags)
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.standard_vpc.id
  cidr_block              = var.subnet_cidrs["public_cidr_3"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"

  tags = merge({ Name = "public-${var.subnet_cidrs["public_cidr_3"]}" }, local.tags)
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.standard_vpc.id
  cidr_block        = var.subnet_cidrs["private_cidr_1"]
  availability_zone = "us-east-1a"

  tags = merge({ Name = "private-${var.subnet_cidrs["private_cidr_1"]}" }, local.tags)
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.standard_vpc.id
  cidr_block        = var.subnet_cidrs["private_cidr_2"]
  availability_zone = "us-east-1b"

  tags = merge({ Name = "private-${var.subnet_cidrs["private_cidr_2"]}" }, local.tags)
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.standard_vpc.id
  cidr_block        = var.subnet_cidrs["private_cidr_3"]
  availability_zone = "us-east-1c"

  tags = merge({ Name = "private-${var.subnet_cidrs["private_cidr_3"]}" }, local.tags)
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.standard_vpc.id

  tags = merge({ Name = "standard-gateway" }, local.tags)
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.standard_vpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_instance.id
  }
  tags = merge({ Name = "private-route-table" }, local.tags)
}

resource "aws_main_route_table_association" "private_route_table" {
  vpc_id         = aws_vpc.standard_vpc.id
  route_table_id = aws_route_table.private_route_table.id

}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_3_association" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.standard_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge({ Name = "public-route-table" }, local.tags)
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_3_association" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "application_security_group" {
  name        = "application-security-group"
  description = "Application security group for private subnets"
  vpc_id      = aws_vpc.standard_vpc.id

}

resource "aws_security_group_rule" "application_security_group_rule_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.application_security_group.id
  self              = true
  description       = "Allow all traffic within application security group"
}

resource "aws_security_group_rule" "application_security_group_rule_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.application_security_group.id
  source_security_group_id = aws_security_group.bastion_security_group.id
  description              = "Allow ssh traffic to application security group"
}

resource "aws_security_group_rule" "application_security_group_rule_outbound" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.application_security_group.id
  source_security_group_id = aws_security_group.nat_security_group.id
  description              = "Allow application security group all traffic out to nat"
}

resource "aws_instance" "nat_instance" {
  ami                         = data.aws_ami.amazon_2_ami.id
  instance_type               = "t3a.micro"
  key_name                    = var.nat_instance_key
  vpc_security_group_ids      = [aws_security_group.nat_security_group.id]
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = <<-EOF
#!/usr/bin/env bash
yum update -y
sysctl -w net.ipv4.ip_forward=1
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
echo "sysctl -w net.ipv4.ip_forward=1" >> /etc/rc.local
echo "/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/rc.local
chmod +x /etc/rc.d/rc.local
EOF

  root_block_device {
    encrypted = true
  }

  tags = merge({ Name = "nat-instance", Service = "NAT" }, local.tags)
}

resource "aws_security_group" "nat_security_group" {
  name        = "nat-security-group"
  description = "Allow private subnet to access public services through a nat instance"
  vpc_id      = aws_vpc.standard_vpc.id

  tags = merge({ Name = "nat-security-group" }, local.tags)
}

resource "aws_security_group_rule" "nat_security_group_rule_app_inbound" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nat_security_group.id
  source_security_group_id = aws_security_group.application_security_group.id
  description              = "Allow all traffic from application security group for nat"
}

resource "aws_security_group_rule" "nat_security_group_rule_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_security_group.id
  description       = "Allow all nat traffic outbound to public"
}

resource "aws_instance" "bastion_instance" {
  ami                         = data.aws_ami.amazon_2_ami.id
  instance_type               = "t3a.micro"
  key_name                    = var.bastion_instance_key
  vpc_security_group_ids      = [aws_security_group.bastion_security_group.id]
  subnet_id                   = aws_subnet.public_subnet_2.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
#!/usr/bin/env bash
yum update -y
EOF

  root_block_device {
    encrypted = true
  }

  tags = merge({ Name = "bastion", Service = "Bastion" }, local.tags)
}

resource "aws_security_group" "bastion_security_group" {
  name        = "bastion-security-group"
  description = "Bastion security group to allow ssh access to private instances"
  vpc_id      = aws_vpc.standard_vpc.id

  tags = merge({ Name = "bastion-security-group" }, local.tags)
}

resource "aws_security_group_rule" "bastion_security_group_rule_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["173.71.168.140/32"]
  security_group_id = aws_security_group.bastion_security_group.id
  description       = "Allow ssh traffic from home address"
}

resource "aws_security_group_rule" "bastion_security_group_rule_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_security_group.id
  description       = "Allow all traffic out"
}

resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  vpc_id       = aws_vpc.standard_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  tags         = merge({ Name = var.vpc_name }, local.tags)
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpc_endpoint_route_association" {
  route_table_id  = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_vpc_endpoint.id
}

//  COMMENTED OUT DO TO COST SAVING! +$7 A DAY

//resource "aws_security_group" "interface_vpc_endpoints_security_group" {
//  name        = "interface-vpc-endpoint-security-group"
//  description = "Security group to allow inbound traffic to interface endpoints"
//  vpc_id      = aws_vpc.standard_vpc.id
//
//  tags = merge({ Name = "interface-vpc-endpoint-security-group" }, local.tags)
//}
//
//resource "aws_security_group_rule" "interface_vpc_endpoints_security_group_rule_inbound" {
//  type              = "ingress"
//  from_port         = 443
//  to_port           = 443
//  protocol          = "tcp"
//  cidr_blocks       = list(var.vpc_cidr_block)
//  security_group_id = aws_security_group.interface_vpc_endpoints_security_group.id
//  description       = "Allow https traffic to interfaces"
//}

//resource "aws_security_group_rule" "interface_vpc_endpoints_security_group_rule_outbound" {
//  type              = "egress"
//  from_port         = 443
//  to_port           = 443
//  protocol          = "tcp"
//  cidr_blocks       = list(var.vpc_cidr_block)
//  security_group_id = aws_security_group.interface_vpc_endpoints_security_group.id
//  description       = "Allow 443 traffic out for ecs and ecr stuff."
//}
//
//resource "aws_vpc_endpoint" "logs_vpc_endpoint" {
//  vpc_id             = aws_vpc.standard_vpc.id
//  service_name       = "com.amazonaws.us-east-1.logs"
//  vpc_endpoint_type  = "Interface"
//  security_group_ids = [aws_security_group.interface_vpc_endpoints_security_group.id]
//  subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
//  tags               = merge({ Name = "logs-interface-endpoint" }, local.tags)
//}
//
//resource "aws_vpc_endpoint" "cloudtrail_vpc_endpoint" {
//  vpc_id             = aws_vpc.standard_vpc.id
//  service_name       = "com.amazonaws.us-east-1.cloudtrail"
//  vpc_endpoint_type  = "Interface"
//  security_group_ids = [aws_security_group.interface_vpc_endpoints_security_group.id]
//  subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
//  tags               = merge({ Name = "cloudtrail-interface-endpoint" }, local.tags)
//}
//
//resource "aws_vpc_endpoint" "kms_vpc_endpoint" {
//  vpc_id             = aws_vpc.standard_vpc.id
//  service_name       = "com.amazonaws.us-east-1.kms"
//  vpc_endpoint_type  = "Interface"
//  security_group_ids = [aws_security_group.interface_vpc_endpoints_security_group.id]
//  subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
//  tags               = merge({ Name = "kms-interface-endpoint" }, local.tags)
//}
//
//resource "aws_vpc_endpoint" "ecr_docker_vpc_endpoint" {
//  vpc_id              = aws_vpc.standard_vpc.id
//  service_name        = "com.amazonaws.us-east-1.ecr.dkr"
//  vpc_endpoint_type   = "Interface"
//  security_group_ids  = [aws_security_group.interface_vpc_endpoints_security_group.id]
//  subnet_ids          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
//  private_dns_enabled = true
//  tags                = merge({ Name = "ecr-docker-interface-endpoint" }, local.tags)
//}
//
//resource "aws_vpc_endpoint" "ecr_api_vpc_endpoint" {
//  vpc_id             = aws_vpc.standard_vpc.id
//  service_name       = "com.amazonaws.us-east-1.ecr.dkr"
//  vpc_endpoint_type  = "Interface"
//  security_group_ids = [aws_security_group.interface_vpc_endpoints_security_group.id]
//  subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
//  tags               = merge({ Name = "ecr-api-interface-endpoint" }, local.tags)
//}
