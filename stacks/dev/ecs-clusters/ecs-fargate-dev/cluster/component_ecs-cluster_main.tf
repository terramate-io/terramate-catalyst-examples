// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "ecs-fargate-dev-dev"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "ecs-fargate-dev-dev"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "8d3d9fdc-e259-4a5c-80fe-cde16193fc6a"
  }
  version = "6.1.0"
}
