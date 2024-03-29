# aws-ipv6
iac for ipv6 on aws
examples for cloudformation, cdk and terraform  

## cloudformation
### vpc templates
vpc stack for dual stack vpc with IPv6 subnets ( 2 public + 2 private)

Parameters:   
  ClassB:  Description: 'Class B of IPv4 VPC (10.XXX.0.0/16)'  
  OwnerName:   An owner name, used in tags  

vpc stack for IPv6 only VPC   ( 2 public + 2 private)

Parameters:   
  ClassB:  Description: 'Class B of IPv4 VPC (10.XXX.0.0/16)'  - not relevant but must be defined
  OwnerName:   An owner name, used in tags  

### status vpc dual stack
aws_100_vpc_dual_stack.yaml

#### ec 2 instances
install
aws_020_ssm_role for SessionManager Connection
  
aws_400/401/402 stacks for ec2 

connect to ec2 instances with Sessions Manager works ( but only in Dual Stack Mode, IPv6 support in Sessions Manager not ready)
ssh from instance to instance works   
ping from instance to instance works 
curl from instance to instance and from internet works  
curl -g -6 'http://[2a05:d01c:c3e:6000:7400:30f3:1a33:bd35]:80/'  

to connect from instance to instance upload the cert  
scp -i C:\workspaces\git-wolfgang\wolfgangireland.pem  ec2-user@0.0.0.0:usr/bin  
scp -i "wolfgangireland.pem" wolfgangireland.pem  ec2-0-0-0-0.eu-west-1.compute.amazonaws.com:/home/ssm-user  

webserver
can be reached by IPv6 address in browser, both in public and private subnet  
http://[2a05:d018:16e5:e200:8910:89f0:9df3:6b98]/

Route 53
aws_110_hosted_zone.yaml  
AAAA record to webserver works (IPv6 address), works both if webserver is in private or public subnet    
CNAME to EC2 DNS name does not work (i-0a9e7fdd1043ab966.eu-west-2.compute.internal)  

ALB Dual Stack working
aws_430_alb.yaml  
TargetGroup changes:
IpAddressType: ipv6
TargetType: ip   
  since outputs in cloudformation for ipv6 addresses are not ready, we have to passe the ipv6 as parameter to the ALB

RS A Alias to ALB working
aws_431_alb_rs.yaml  

#### Elastic Beanstalk
not supported yet for IPv6  

#### RDS
see stack aws_320_rds  
setting up a rds mysql in dual stack mode is possible with cfn  
see MYSQL documentation for IPv6 support and allow connecting  
https://dev.mysql.com/doc/refman/8.0/en/ipv6-support.html  

#### ECS/Fargate  
works but some steps required  

works easy with a public ipv4 address, see stack aws_540_service_public_ip4
of course not possible with private ipv4 address ( no NAT)
with IPv6 see:
VPC Endpoints to enable ECR communication :  
aws_541_vpc_endpoints  
Fargate Service without ALB see Stack aws_542_service_private_ip6  
Fargate Service with ALB see Stack aws_543_service_private_ip6_alb  

https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-networking.html  
checklist:   
-The task or service uses Fargate platform version 1.4.0 or later for Linux. (yes)    
-Your VPC and subnet are enabled for IPv6 (yes)  
-Your subnet is enabled for auto-assigning IPv6 addresses (yes).  
-Your Amazon ECS dualStackIPv6 account setting is turned on (yes)  
see:  
enabling ecs ipv6 account settings    
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-networking.html#fargate-task-networking-vpc-dual-stack  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-account-settings.html  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/account-setting-management-cli.html  
dualStackIPv6 can only be set via commandline:    
aws ecs put-account-setting-default --name dualStackIPv6 --value enabled (--region eu-west-1)      
aws ecs put-account-setting --name dualStackIPv6 --value enabled (--region eu-west-1)      
  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-networking.html  
  
issue pulling the image  :  
still not connecting with in private subnet with IPv6 address. Only possible with public IPv4 address , ECR enpoint not IPv6 ready   
so VPC endpoints required, see stack aws_541_endpoints   
2 interface Endpoints for  
com.amazonaws.region.ecr.dkr  
and  
com.amazonaws.region.ecr.api  
both linked to your IPv6 VPC and private Subnets.  
You need to create also a Gateway Endpoint to  
com.amazonaws.region.s3  
for cloudwatch you need also  
.0/16	com.amazonaws.region.logs  

for interface endpoints, the private subnets must be asociated  
for the gateway endpoint, the private route tables must be asociated  
your service security group must be asociated to the VPC endpoints !   



### status vpc ipv6 only  
connect to ec2 instances with Sessions Manager not working
ssh from instance to instance works   
ping from instance to instance works 
curl from instance to instance and from internet works  

Route 53
AAAA record to webserver works (IPv6 address), works both if webserver is in private or public subnet    

#### Elastic Beanstalk
not supported yet for IPv6  

#### RDS
Not yet IPv6 only support  

### ec2 templates
status, see vpc findings

### fargate
no IPv6 support  



## terraform
VPC IPv6 dual stack or IPv6 only  
EC2 instances:  
Web server can be called directly by IPv6 address  
http://[]  
or by Route53 AAAA recordset  
Loadbalancer for EC2 instance  
can be called by R53 Recordset A Alias  
RDS with IPv6 working 
no Elastic Beanstalk example, not supported, see CFN  
  
## cdk
first IPv6 Dual Stack VPC created     
DualStack IPv6 VPC with 2 public and 2 private Subnets  
No NAT  
IGW and EgressOnly IGW and routes  
no further EC2, RDS or Fargate examples yet, since funcionality will work the same way as for CFN and terraform examples   

## references  
https://docs.aws.amazon.com/vpc/latest/userguide/aws-ipv6-support.html    
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-networking.html  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-account-settings.html  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/account-setting-management-cli.html  
https://dev.mysql.com/doc/refman/8.0/en/ipv6-support.html   