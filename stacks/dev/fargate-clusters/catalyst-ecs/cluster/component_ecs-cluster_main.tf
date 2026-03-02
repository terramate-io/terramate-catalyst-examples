// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "catalyst-ecs-dev"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "catalyst-ecs"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "adccd7be-c2fe-4571-9a2c-b0c5b446956a"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "dev"
  }
  version = "6.1.0"
}
