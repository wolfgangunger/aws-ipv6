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