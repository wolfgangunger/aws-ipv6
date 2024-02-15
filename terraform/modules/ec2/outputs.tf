output "web_server_instance_id" {
  description = "The ID of web server instance"
  value       = aws_instance.ipv6_instance.id
}

output "web_server_ipv6_addresses" {
  description = "The IPv6 address of web server instance"
  value       = aws_instance.ipv6_instance.ipv6_addresses
}