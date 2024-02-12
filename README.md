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
#### ec 2 instances
connect to ec2 instances with Sessions Manager works ( but only in Dual Stack Mode, IPv6 support in Sessions Manager not ready)
ssh from instance to instance works   
ping from instance to instance works 
curl from instance to instance and from internet works  
curl -g -6 'http://[2a05:d01c:c3e:6000:7400:30f3:1a33:bd35]:80/'  

Route 53
AAAA record to webserver works (IPv6 address), works both if webserver is in private or public subnet    
CNAME to EC2 DNS name does not work (i-0a9e7fdd1043ab966.eu-west-2.compute.internal)  

ALB Dual Stack working
RS A Alias to ALB working

#### Elastic Beanstalk
not supported yet for IPv6  

#### RDS
see stack aws_320_rds  
setting up a rds mysql in dual stack mode is possible with cfn  
see MYSQL documentation for IPv6 support and allow connecting  
https://dev.mysql.com/doc/refman/8.0/en/ipv6-support.html  

### status vpc ipv6 only  
connect to ec2 instances with Sessions Manager not working
ssh from instance to instance works   
ping from instance to instance works 
curl from instance to instance and from internet works  

Route 53
AAAA record to webserver works (IPv6 address), works both if webserver is in private or public subnet    

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
