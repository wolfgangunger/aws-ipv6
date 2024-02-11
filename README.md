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

# status
## ec 2 instances
connect to ec2 instances with Sessions Manager works ( but only in Dual Stack Mode, IPv6 support in Sessions Manager not ready)
ssh from instance to instance works   
ping from instance to instance works 
curl from instance to instance and from internet works  
curl -g -6 'http://[2a05:d01c:c3e:6000:7400:30f3:1a33:bd35]:80/'  

Route 53
AAAA record to webserver works (IPv6 address), works both if webserver is in private or public subnet    
CNAME to EC2 DNS name does not work (i-0a9e7fdd1043ab966.eu-west-2.compute.internal)  


### ec2 templates

#### findings
output for ec2 ipv6 address not ready 

## terraform
todo  
  
## cdk
todo  
