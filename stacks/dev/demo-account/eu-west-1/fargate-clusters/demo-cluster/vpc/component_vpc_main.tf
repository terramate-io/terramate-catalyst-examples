// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "aws_availability_zones" "available" {
}
module "vpc" {
  azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr               = "10.0.0.0/16"
  enable_nat_gateway = true
  name               = "demo-cluster-dev"
  private_subnets = [
    "10.0.0.0/20",
    "10.0.16.0/20",
    "10.0.32.0/20",
  ]
  public_subnets = [
    "10.0.48.0/24",
    "10.0.49.0/24",
    "10.0.50.0/24",
  ]
  single_nat_gateway = true
  source             = "terraform-aws-modules/vpc/aws"
  tags = {
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "demo-cluster"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "86010748-238b-463a-ae07-3293bbd8e488"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "dev"
  }
  version = "6.5.1"
}
