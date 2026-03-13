// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "null_resource" "initial_deployment_trigger" {
}
data "aws_ecs_cluster" "cluster" {
  cluster_name = "demo-ecs-cluster-dev"
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
      "5de03a97-0509-431f-a786-eb632a2bd66d",
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
  name = "demo-ecs-cluster-dev"
}
data "aws_lb_target_group" "group" {
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
  name = "demo-ecs-cluster-nginx-demo"
}
