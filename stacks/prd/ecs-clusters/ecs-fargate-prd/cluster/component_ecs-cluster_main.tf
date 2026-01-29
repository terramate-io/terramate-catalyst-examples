// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_cluster" {
  cluster_name = "ecs-fargate-prd-prd"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "ecs-fargate-prd-prd"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "25747df9-fc8e-4f67-b085-2acc7b47c47b"
  }
  version = "6.1.0"
}
