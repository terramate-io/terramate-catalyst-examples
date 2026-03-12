// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "null_resource" "initial_deployment_trigger" {
}
data "aws_ecs_cluster" "cluster" {
  cluster_name = "ecs-fargate-catalyst-demo-prd"
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
}
data "aws_vpc" "vpc" {
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
  filter {
    name = "tag:example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"
    values = [
      "c2a0ddaf-fdd6-4b4a-88d1-9f4c5273e7bf",
    ]
  }
}
data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc.id,
    ]
  }
  filter {
    name = "tag:Name"
    values = [
      "*-private-*",
    ]
  }
}
data "aws_lb" "alb" {
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
  name = "ecs-fargate-catalyst-demo-prd"
}
data "aws_lb_target_group" "group" {
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
  name = "ecs-fargate-catalyst-demo-nginx-"
}
