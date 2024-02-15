locals {
  KeyName = "IPV6KeyPair"
}

# uses a cloudformation stack to create the key pair, this makes the private_key be stored in SSM Parameter Store under the path /ec2/keypair/{key_pair_id}
resource "aws_cloudformation_stack" "ipv6_key_pair" {
  name = "IPV6KeyPair"
  template_body = jsonencode({

    Resources = {
      BastionKeyPair = {
        "Type" : "AWS::EC2::KeyPair",
        "Properties" : {
          "KeyName" : "${local.KeyName}",
          "KeyType" : "rsa"
        }
      }
    }
  })
}

##Create a ec2 instance with a simple webserver using ipv6, using terraform
resource "aws_instance" "ipv6_instance" {
  ami                      = data.aws_ami.amazonlinux.id
  instance_type            = var.instance_type
  iam_instance_profile     = aws_iam_instance_profile.ipv6_instance_profile.name
  subnet_id          = var.subnet_public_a_id
  ipv6_address_count = 1
  vpc_security_group_ids = [aws_security_group.web.id]
  associate_public_ip_address = false
  key_name                    = local.KeyName

  user_data = <<EOF
		#!/bin/bash -xe
    sudo yum install -y httpd
    sudo chkconfig httpd on
    sudo service httpd start
    EOF

  tags = {
    Name = "IPV6-enabled-ec2"
  }

  depends_on = [
    aws_cloudformation_stack.ipv6_key_pair
  ]

}

data "aws_ami" "amazonlinux" {
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

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow inbound traffic on port 80 and 443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web"
  }
}

resource "aws_iam_instance_profile" "ipv6_instance_profile" {
  name = "ipv6_instance_profile-${var.env}"
  role = aws_iam_role.ipv6_instance_role.name
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ipv6_instance_role" {
  name               = "ipv6_instance_role-${var.env}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}