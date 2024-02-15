from constructs import Construct
from aws_cdk import (
    aws_ec2 as ec2,
    Fn   
)

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
            #ipv6Addresses=
            create_internet_gateway=True,
            nat_gateway_provider=None,
            nat_gateways = 0,
            vpc_name="VPC-IPv6-Dual-Stack",
            **kwargs)

        # make an ipv6 cidr
        ipv6cidr = ec2.CfnVPCCidrBlock(self, "CIDR6",
            vpc_id=self.vpc_id,
            amazon_provided_ipv6_cidr_block=True
        )
        ## egress only igw
        cfn_egress_only_internet_gateway = ec2.CfnEgressOnlyInternetGateway(self, "EgressOnly IGW",
            vpc_id=self.vpc_id,
        )

        # connect the ipv6 cidr to all vpc subnets
        subnetcount = 0
        for pubsubnet in self.public_subnets: 
            pubsubnet.node.add_dependency(ipv6cidr)
            pubsubnet.type = ec2.SubnetType.PUBLIC
            pubsubnet.name = "Public " + str(subnetcount)
            associate_subnet_with_v6_cidr(self, subnetcount, pubsubnet)
            #pubsubnet.add_ipv6_default_internet_route(self.internet_gateway_id)
            #pubsubnet.add_route("IPv6", router_id=self.internet_gateway_id, router_type="InternetGateway",destination_ipv6_cidr_block="" )
            subnetcount = subnetcount + 1  
        for privsubnet in self.private_subnets: 
            privsubnet.node.add_dependency(ipv6cidr)
            privsubnet.type = ec2.SubnetType.PRIVATE_WITH_EGRESS
            privsubnet.name = "Private" + str(subnetcount- 2)
            associate_subnet_with_v6_cidr(self, subnetcount, privsubnet)
            #privsubnet.add_route("Default", router_id=cfn_egress_only_internet_gateway.ref, router_type="EgressOnlyInternetGateway")
            privsubnet.add_ipv6_default_egress_only_internet_route(cfn_egress_only_internet_gateway)
            subnetcount = subnetcount + 1     



   
