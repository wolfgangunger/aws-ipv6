# aws-ipv6
iac for ipv6 on aws
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
wip    
enabled ecs ipv6 account settings  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-networking.html#fargate-task-networking-vpc-dual-stack  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-account-settings.html  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/account-setting-management-cli.html  
dualStackIPv6 can only be set via commandline:    
aws ecs put-account-setting-default --name dualStackIPv6 --value enabled --region eu-west-1    
aws ecs put-account-setting --name dualStackIPv6 --value enabled --region eu-west-1    
  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-networking.html  

issue pulling the image  
still not connecting with in private subnet with IPv6 address. Only possible with public IPv4 address

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

#### findings
output for ec2 ipv6 address not ready 

## terraform
todo  
  
## cdk
todo  

#### references  
https://docs.aws.amazon.com/vpc/latest/userguide/aws-ipv6-support.html    
