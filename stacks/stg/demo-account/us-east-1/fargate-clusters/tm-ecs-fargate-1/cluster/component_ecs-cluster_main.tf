// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "tm-ecs-fargate-1-stg"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "tm-ecs-fargate-1"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "7b507255-36bc-4f49-aa62-feeb7844975a"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "stg"
  }
  version = "6.1.0"
}
