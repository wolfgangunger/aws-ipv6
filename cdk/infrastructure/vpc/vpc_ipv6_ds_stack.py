from constructs import Construct
from aws_cdk import (
    Duration,
    Stack,
    aws_iam as iam,
    aws_sqs as sqs,
    aws_sns as sns,
    aws_sns_subscriptions as subs,
)

from infrastructure.vpc.vpc_ipv6_ds_construct import VPCIPv6DualStackConstruct 



class VPCIPv6DualStackStack(Stack):

    def __init__(
            self, 
            scope: Construct, 
            construct_id: str, 
            cidr_range: str,
            **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        VPCIPv6DualStackConstruct(
            self,
            f"-vpc-ipv6",
            cidr_range,
        )
