-Docker Build:
docker build -f Dockerfile -t xxx.dkr.ecr.eu-west-2.amazonaws.com/ecs-repository-ipv6:flask .
docker build -f Dockerfile -t xxx.dkr.ecr.eu-west-1.amazonaws.com/ecs-repository-ipv6:httpd .
-ECR Login
$(aws ecr get-login --no-include-email --region us-west-2)
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin xxx.dkr.ecr.eu-west-1.amazonaws.com
-Docker push:
 docker push xxx.dkr.ecr.eu-west-2.amazonaws.com/ecs-repository-ipv6:httpd



scp -i C:\workspaces\git-wolfgang> 
scp -i C:\workspaces\git-wolfgang\wolfgangireland.pem  ec2-user@0.0.0.0:usr/bin
scp -i "wolfgangireland.pem" wolfgangireland.pem  ec2-0-0-0-0.eu-west-1.compute.amazonaws.com:/home/ssm-user
 