// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "dev-cluster-dev"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "dev-cluster-dev"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "2cfe746a-f0ee-4ead-af0b-21705419b2a5"
  }
  version = "6.1.0"
}
