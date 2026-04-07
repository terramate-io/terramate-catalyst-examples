// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "aws_availability_zones" "available" {
}
module "vpc" {
  azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr               = "10.10.0.0/16"
  enable_nat_gateway = true
  name               = "demo-account-dev-cluster-stg"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "demo-account-dev-cluster"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "c4c99d29-d82e-4849-bfcd-34a68b630aaf"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "stg"
  }
  version = "6.5.1"
}
