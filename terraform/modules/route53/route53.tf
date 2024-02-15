locals {
  # Removing trailing dot from domain - just to be sure
  domain_name = trimsuffix(var.route53_domain, ".")
}

resource "aws_route53_zone" "hosted_zone" {
  name = local.domain_name
}
