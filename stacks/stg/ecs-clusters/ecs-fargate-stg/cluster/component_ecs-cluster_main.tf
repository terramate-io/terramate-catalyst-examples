// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "ecs-fargate-stg-stg"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "ecs-fargate-stg-stg"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "4f9b71ce-f805-407d-80f9-9527e0690fd1"
  }
  version = "6.1.0"
}
