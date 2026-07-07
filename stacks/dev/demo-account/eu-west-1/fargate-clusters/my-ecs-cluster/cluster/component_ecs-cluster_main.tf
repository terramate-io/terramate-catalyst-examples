// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "my-ecs-cluster-dev"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "my-ecs-cluster"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "3b6d4582-319c-45b1-952e-d96a3e74faad"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "dev"
  }
  version = "6.1.0"
}
