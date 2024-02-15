from constructs import Construct
from aws_cdk import (
    aws_ec2 as ec2,

)

from infrastructure.vpc.vpc_ipv6_ds import VPCIPv6DualStack

class VPCIPv6DualStackConstruct(Construct):

    def __init__(
        self,
        scope: Construct,
        id: str,
        cidr_range: str,
        **kwargs,
    ) -> None:
        super().__init__(scope, id, **kwargs)


        # create a vpc               
        # vpc = ec2.Vpc(self, "VPC-Dual-Stack",
        #     ip_addresses=ec2.IpAddresses.cidr("10.0.0.0/16")
        # )   
        # create a vpc with ipv6 dual stack        
        vpcipv6 =   VPCIPv6DualStack(self, "VPC-IPv6-Dual-Stack",cidr_range)   


   
