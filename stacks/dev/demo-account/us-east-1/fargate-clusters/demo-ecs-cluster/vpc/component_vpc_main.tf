// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "aws_availability_zones" "available" {
}
module "vpc" {
  azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr               = "10.10.0.0/16"
  enable_nat_gateway = true
  name               = "demo-ecs-cluster-dev"
  private_subnets = [
    "10.10.0.0/20",
    "10.10.16.0/20",
    "10.10.32.0/20",
  ]
  public_subnets = [
    "10.10.48.0/24",
    "10.10.49.0/24",
    "10.10.50.0/24",
  ]
  single_nat_gateway = true
  source             = "terraform-aws-modules/vpc/aws"
  tags = {
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "demo-ecs-cluster"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "5de03a97-0509-431f-a786-eb632a2bd66d"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "dev"
  }
  version = "6.5.1"
}
