data "aws_availability_zones" "available" {}

locals {
  azs                          = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_ipv6_prefixes  = [0, 1, 2]
  private_subnet_ipv6_prefixes = [3, 4, 5]
}

resource "aws_vpc" "ipv6_vpc" {

  cidr_block = "10.${var.class_B}.0.0/16"

  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name = "IPv6 VPC 10.${var.class_B}.0.0/16"
  }
}

## Public Subnets ##

resource "aws_subnet" "public-a" {

  vpc_id                                         = aws_vpc.ipv6_vpc.id
  assign_ipv6_address_on_creation                = true
  map_public_ip_on_launch                        = false
  availability_zone                              = local.azs[0]
  cidr_block                                     = "10.${var.class_B}.0.0/20"
  enable_dns64                                   = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.ipv6_vpc.ipv6_cidr_block, 8, local.public_subnet_ipv6_prefixes[0])


  tags = {
    Name = "A public"
  }
}

resource "aws_subnet" "public-b" {

  vpc_id                                         = aws_vpc.ipv6_vpc.id
  assign_ipv6_address_on_creation                = true
  map_public_ip_on_launch                        = false
  availability_zone                              = local.azs[1]
  cidr_block                                     = "10.${var.class_B}.16.0/20"
  enable_dns64                                   = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.ipv6_vpc.ipv6_cidr_block, 8, local.public_subnet_ipv6_prefixes[1])


  tags = {
    Name = "B public"
  }
}

## Private Subnets ##

resource "aws_subnet" "private-a" {

  vpc_id                                         = aws_vpc.ipv6_vpc.id
  assign_ipv6_address_on_creation                = true
  availability_zone                              = local.azs[0]
  cidr_block                                     = "10.${var.class_B}.32.0/20"
  enable_dns64                                   = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.ipv6_vpc.ipv6_cidr_block, 8, local.private_subnet_ipv6_prefixes[0])


  tags = {
    Name = "A private"
  }
}

resource "aws_subnet" "private-b" {

  vpc_id                                         = aws_vpc.ipv6_vpc.id
  assign_ipv6_address_on_creation                = true
  availability_zone                              = local.azs[1]
  cidr_block                                     = "10.${var.class_B}.48.0/20"
  enable_dns64                                   = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.ipv6_vpc.ipv6_cidr_block, 8, local.private_subnet_ipv6_prefixes[1])


  tags = {
    Name = "B private"
  }
}

### Internet Gateway and Egress Only Gateway ##

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.ipv6_vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_egress_only_internet_gateway" "eigw" {

  vpc_id = aws_vpc.ipv6_vpc.id

  tags = {
    Name = "EIGW"
  }
}

### Routes & Route Tables ##

#public routes

resource "aws_route" "public_internet_gateway_route" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_route_ipv6" {

  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.ipv6_vpc.id

  tags = {
    Name = "RouteTable  Public"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public.id
}

#private routes

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.ipv6_vpc.id

  tags = {
    Name = "RouteTable  Private"
  }
}

resource "aws_route" "private_ipv6_egress" {

  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.eigw.id
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.private.id
}

### ACL Public
resource "aws_network_acl" "public" {

  vpc_id = aws_vpc.ipv6_vpc.id

  tags = {
    Name = "ACL Public"
  }
}

resource "aws_network_acl_association" "public-a" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public-a.id
}

resource "aws_network_acl_association" "public-b" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public-b.id
}

resource "aws_network_acl_rule" "public_inbound_allow_all_ipv4" {

  network_acl_id = aws_network_acl.public.id

  egress      = false
  rule_number = 100
  rule_action = "allow"
  protocol    = -1
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_inbound_allow_all_ipv6" {

  network_acl_id = aws_network_acl.public.id

  egress          = false
  rule_number     = 101
  rule_action     = "allow"
  protocol        = -1
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_outbound_allow_all_ipv4" {

  network_acl_id = aws_network_acl.public.id

  egress      = true
  rule_number = 100
  rule_action = "allow"
  protocol    = -1
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_outbound_allow_all_ipv6" {

  network_acl_id = aws_network_acl.public.id

  egress          = true
  rule_number     = 101
  rule_action     = "allow"
  protocol        = -1
  ipv6_cidr_block = "::/0"
}

# ACL Private
resource "aws_network_acl" "private" {

  vpc_id = aws_vpc.ipv6_vpc.id

  tags = {
    Name = "ACL Private"
  }
}

resource "aws_network_acl_association" "private-a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private-a.id
}

resource "aws_network_acl_association" "private-b" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private-b.id
}

resource "aws_network_acl_rule" "private_inbound_allow_all_ipv4" {

  network_acl_id = aws_network_acl.private.id

  egress      = false
  rule_number = 100
  rule_action = "allow"
  protocol    = -1
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_inbound_allow_all_ipv6" {

  network_acl_id = aws_network_acl.private.id

  egress          = false
  rule_number     = 101
  rule_action     = "allow"
  protocol        = -1
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_outbound_allow_all_ipv4" {

  network_acl_id = aws_network_acl.private.id

  egress      = true
  rule_number = 100
  rule_action = "allow"
  protocol    = -1
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_outbound_allow_all_ipv6" {

  network_acl_id = aws_network_acl.private.id

  egress          = true
  rule_number     = 101
  rule_action     = "allow"
  protocol        = -1
  ipv6_cidr_block = "::/0"
}


# Flow Logs

resource "aws_cloudwatch_log_group" "cloudwatch_flow_logs_group" {
  name              = "FlowLogsGroup"
  retention_in_days = 365
}

resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.cloudwatch_flow_logs_group.arn
  vpc_id          = aws_vpc.ipv6_vpc.id
  traffic_type    = "ALL"

  tags = {
    Name  = "IPV6-vpc-FlowLog"
  }
}


resource "aws_iam_role" "flow_log_role" {
  name               = "FlowLogRole-${var.env}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow_log_role_policy" {
  name   = "FlowLogRolePolicy"
  role   = aws_iam_role.flow_log_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}