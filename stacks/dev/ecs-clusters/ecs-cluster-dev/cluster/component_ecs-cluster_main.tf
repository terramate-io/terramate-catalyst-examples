// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "ecs-cluster-dev-dev"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "ecs-cluster-dev-dev"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "79a83f2e-dbc0-429e-80e0-d0c395f0f605"
  }
  version = "6.1.0"
}
