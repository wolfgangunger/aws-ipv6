-Docker Build:
private repo 
docker build -f Dockerfile -t xxx.dkr.ecr.eu-west-2.amazonaws.com/ecs-repository-ipv6:flask .
docker build -f Dockerfile -t xxx.dkr.ecr.eu-west-1.amazonaws.com/ecs-repository-ipv6:httpd .
public repo 
docker build -f Dockerfile -t public.ecr.aws/xxx/public-ecr-ireland:httpd .

-ECR Login (private repo)
$(aws ecr get-login --no-include-email --region us-west-2)
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin xxx.dkr.ecr.eu-west-1.amazonaws.com
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin public.ecr.aws/xxx/public-ecr-ireland
-Docker push:
private 
docker push xxx.dkr.ecr.eu-west-2.amazonaws.com/ecs-repository-ipv6:httpd
public
docker push public.ecr.aws/xxx/public-ecr-ireland:httpd




 