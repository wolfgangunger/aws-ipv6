resource "aws_route53_record" "webserver_record" {
  name    = "webserver.${var.route53_domain}"
  type    = "AAAA"
  zone_id = var.hosted_zone_id

  ttl     = 300
  records = aws_instance.ipv6_instance.ipv6_addresses
}