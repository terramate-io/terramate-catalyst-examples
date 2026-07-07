// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "my-cluster-dev"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "my-cluster"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "11ef4fb6-7cf9-4740-b2b1-1e6cbdace260"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "dev"
  }
  version = "6.1.0"
}
