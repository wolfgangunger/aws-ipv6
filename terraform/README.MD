## About

This is an example of a terraform code to deploy a vpc using ipv6, 2 private and 2 public subnets, with flow logs, and without nat gateways.

## Structure

└── terraform/  
   ├── modules/  
   │   ├── vpc/  
   │   │   ├── vpc.tf  
   │   │   ├── outputs.tf  
   │   │   └── variables.tf  
   │   └── ec2/  
   │       ├── ec2.tf  
   │       ├── outputs.tf  
   │       └── variables.tf  
   │   └── more-modules/  
   |
   ├── main.tf  
   ├── variables.tf   
   └── terraform.tfvars   

## Configure the variables 

The terraform.tfvars contains some variable values that must be informed before deplot the terraform.

## Deploying infrastructure with terraform

AWS Credentials:
Use the aws configure command to configure your terminal to use the credentials(Access Key and Secret Key) of your iam user.

Init:
Use the terraform init command to initialyze the terraform 
  
  Ps: When creating or changing between backend configurations use the -reconfigure option.

Plan:   
terraform plan
  
Apply:    
terraform apply 
  
Destroy:  
terraform destroy
  
### functionality  
VPC IPv6 dual stack or IPv6 only  
EC2 instances:  
Web server can be called directly by IPv6 address  
http://[]  
or by Route53 AAAA recordset  
Loadbalancer for EC2 instance  
can be called by R53 Recordset A Alias  
