terraform {
  #required_version = "1.7.3"
  required_version = "1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.36.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform = "true"
      Group     = var.project_name
    }
  }
}

# Create a new VPC
## dual stack "./modules/vpc_dual_stack
## vpc only "./modules/vpc_ipv6_only
## vpc with module
module "vpc" {
  source = "./modules/vpc_dual_stack" 
  class_B      = var.class_B
  project_name = var.project_name
  owner        = var.owner
  aws_region   = var.aws_region
  env = var.env
}

# Create an Hosted Zone on Route 53
module "route53" {
  source = "./modules/route53"

  route53_domain = var.route53_domain
}

# Create an EC2 instance running apache
module "ec2_webserver" {
  source = "./modules/ec2"
  route53_domain = var.route53_domain

  subnet_public_a_id = module.vpc.subnet_public_a_id
  hosted_zone_id     = module.route53.hosted_zone_id
  vpc_id    = module.vpc.vpc_id
  env = var.env

}

#### ALB with terraform do not work in ipv6 only vpc ###
# Create an ALB to the Web Server
module "alb" {
  source         = "./modules/alb"
  route53_domain = var.route53_domain

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_b_id]
  hosted_zone_id            = module.route53.hosted_zone_id
  web_server_ipv6_addresses = module.ec2_webserver.web_server_ipv6_addresses
}

# Create an RDS mysql database
module "rds" {
  source  = "./modules/rds"

  ipv6_cidr_block   = module.vpc.ipv6_cidr_block
  vpc_id            = module.vpc.vpc_id
  private_subnets   = [module.vpc.subnet_private_a_id, module.vpc.subnet_private_b_id]
  project_name      = var.project_name
  env               = var.env
}
