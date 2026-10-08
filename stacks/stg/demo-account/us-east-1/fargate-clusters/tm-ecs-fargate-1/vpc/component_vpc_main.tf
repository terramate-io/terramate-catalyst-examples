// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "aws_availability_zones" "available" {
}
module "vpc" {
  azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr               = "10.1.0.0/16"
  enable_nat_gateway = true
  name               = "tm-ecs-fargate-1-stg"
  private_subnets = [
    "10.1.0.0/20",
    "10.1.16.0/20",
    "10.1.32.0/20",
  ]
  public_subnets = [
    "10.1.48.0/24",
    "10.1.49.0/24",
    "10.1.50.0/24",
  ]
  single_nat_gateway = true
  source             = "terraform-aws-modules/vpc/aws"
  tags = {
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "tm-ecs-fargate-1"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "7b507255-36bc-4f49-aa62-feeb7844975a"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "stg"
  }
  version = "6.5.1"
}
