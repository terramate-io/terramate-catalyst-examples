// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "terramate-catalyst-fargate-cluster-prd"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "terramate-catalyst-fargate-cluster"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "9e932e1e-097f-4b22-b6e6-32cb98048b86"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "prd"
  }
  version = "6.1.0"
}
