

resource "aws_lb" "alb_web_server" {
  name               = "alb-web-server"
  internal           = false
  load_balancer_type = "application"
  enable_http2       = true
  ip_address_type    = "dualstack"
  security_groups    = [aws_security_group.alb_api_sg.id]
  subnets            = var.subnet_ids

}


resource "aws_lb_listener" "api_server_listener" {
  load_balancer_arn = aws_lb.alb_web_server.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_server_target_group.arn
  }
}

resource "aws_lb_target_group" "api_server_target_group" {
  name     = "web-server-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type     = "ip" # Verify why it only works with the ip option instead of instance
  ip_address_type = "ipv6"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment_web_server" {
  target_group_arn = aws_lb_target_group.api_server_target_group.arn
  target_id        = var.web_server_ipv6_addresses[0] # var.web_server_instance_id 
  port             = 80
}

resource "aws_security_group" "alb_api_sg" {
  name        = "alb_webserver_sg"
  description = "Allow inbound traffic on port 80 and 443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_route53_record" "alb_record" {
  name    = "alb.${var.route53_domain}"
  type    = "AAAA"
  zone_id = var.hosted_zone_id

  alias {
    name                   = aws_lb.alb_web_server.dns_name
    zone_id                = aws_lb.alb_web_server.zone_id
    evaluate_target_health = false
  }
}