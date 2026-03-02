// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "null_resource" "initial_deployment_trigger" {
}
data "aws_ecs_cluster" "cluster" {
  cluster_name = "catalyst-ecs-dev"
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
      "adccd7be-c2fe-4571-9a2c-b0c5b446956a",
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
  name = "catalyst-ecs-dev"
}
data "aws_lb_target_group" "group" {
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
  name = "catalyst-ecs-catalyst-nginx"
}
