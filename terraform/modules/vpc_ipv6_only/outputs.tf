output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.ipv6_vpc.id
}

output "subnet_public_a_id" {
  description = "The IDs of the subnet public a"
  value       = aws_subnet.public-a.id
}

output "subnet_public_b_id" {
  description = "The IDs of the subnet public b"
  value       = aws_subnet.public-b.id
}

output "subnet_private_a_id" {
  description = "The IDs of the subnet private a"
  value       = aws_subnet.private-a.id
}

output "subnet_private_b_id" {
  description = "The IDs of the subnet private b"
  value       = aws_subnet.private-b.id
}

output "ipv6_cidr_block" {
  description = "The IPV6 CIDR block of the VPC"
  value       = aws_vpc.ipv6_vpc.ipv6_cidr_block
}