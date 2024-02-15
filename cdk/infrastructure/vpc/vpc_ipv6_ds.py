from constructs import Construct
from aws_cdk import (
    aws_ec2 as ec2,
    Fn   
)
#https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_ec2/Vpc.html

def associate_subnet_with_v6_cidr(vpc, count, subnet):    
    cfn_subnet = subnet.node.default_child
    cfn_subnet.ipv6_cidr_block = Fn.select(count, Fn.cidr(Fn.select(0, vpc.vpc_ipv6_cidr_blocks), 256, str(128 - 64)))
    cfn_subnet.assign_ipv6_address_on_creation = True

class VPCIPv6DualStack(ec2.Vpc):

    def __init__(
        self,
        scope: Construct,
        id: str,
        cidr_range: str,
        **kwargs,
    ) -> None:
        super().__init__(
            scope, 
            id, 
            ip_addresses= ec2.IpAddresses.cidr(cidr_range),
            ip_protocol=ec2.IpProtocol.DUAL_STACK,
            subnet_configuration=[
                    ec2.SubnetConfiguration(
                    subnet_type=ec2.SubnetType.PUBLIC,
                    name='Public A',
                    cidr_mask=20,
                    ipv6_assign_address_on_creation=True,
                    map_public_ip_on_launch=True
                    ), 
                    ec2.SubnetConfiguration(
                    subnet_type=ec2.SubnetType.PRIVATE_WITH_EGRESS,
                    name='Private A',
                    cidr_mask=20,
                    ipv6_assign_address_on_creation=True
                    ), 
                    ],
            create_internet_gateway=True,
            nat_gateway_provider=None,
            nat_gateways = 0,
            vpc_name="VPC-IPv6-Dual-Stack",
            **kwargs)

        # make an ipv6 cidr
        # ipv6cidr = ec2.CfnVPCCidrBlock(self, "CIDR6",
        #     vpc_id=self.vpc_id,
        #     amazon_provided_ipv6_cidr_block=True
        # )
        ## egress only igw
        # cfn_egress_only_internet_gateway = ec2.CfnEgressOnlyInternetGateway(self, "EgressOnly IGW",
        #     vpc_id=self.vpc_id,
        # )
        
        # connect the ipv6 cidr to all vpc subnets
        # subnetcount = 0
        # for pubsubnet in self.public_subnets: 
        #     pubsubnet.node.add_dependency(ipv6cidr)
        #     pubsubnet.type = ec2.SubnetType.PUBLIC
        #     pubsubnet.name = "Public " + str(subnetcount)
        #     associate_subnet_with_v6_cidr(self, subnetcount, pubsubnet)
        #     #pubsubnet.add_ipv6_default_internet_route(self.internet_gateway_id)
        #     subnetcount = subnetcount + 1  
        #     pubsubnet.tags = [{"key": "Name", "value": "Public " + str(subnetcount)}]
        # for privsubnet in self.private_subnets: 
        #     privsubnet.node.add_dependency(ipv6cidr)
        #     privsubnet.type = ec2.SubnetType.PRIVATE_WITH_EGRESS
        #     privsubnet.name = "Private" + str(subnetcount- 2)
        #     privsubnet.tags = [{"key": "Name", "value": "Private " + str(subnetcount)}]
        #     associate_subnet_with_v6_cidr(self, subnetcount, privsubnet)
        #     #privsubnet.add_ipv6_default_egress_only_internet_route(cfn_egress_only_internet_gateway.attr_id)
        #     subnetcount = subnetcount + 1     



   
