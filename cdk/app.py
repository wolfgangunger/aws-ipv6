#!/usr/bin/env python3

import aws_cdk as cdk


from infrastructure.vpc.vpc_ipv6_ds_stack import VPCIPv6DualStackStack



app = cdk.App()

## vpc ipv6 dualstack
VPCIPv6DualStackStack(app, "vpc-ipv6-dualstack", "10.1.0.0/16")

app.synth()
