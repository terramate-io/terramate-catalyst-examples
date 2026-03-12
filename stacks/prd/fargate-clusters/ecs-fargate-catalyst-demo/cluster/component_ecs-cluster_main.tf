// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "ecs-fargate-catalyst-demo-prd"
  default_capacity_provider_strategy = {
    FARGATE = {
      base   = 20
      weight = 50
    }
    FARGATE_SPOT = {
      weight = 50
    }
  }
  source = "terraform-aws-modules/ecs/aws"
  tags = {
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "ecs-fargate-catalyst-demo"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "c2a0ddaf-fdd6-4b4a-88d1-9f4c5273e7bf"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "prd"
  }
  version = "6.1.0"
}
