// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "null_resource" "initial_deployment_trigger" {
}
data "aws_ecs_cluster" "cluster" {
  cluster_name = "demo-cluster-dev"
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
      "1e65e331-1e64-400d-8123-bf5f93294fa4",
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
  name = "demo-cluster-dev"
}
data "aws_lb_target_group" "group" {
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
  name = "demo-cluster-my-first-service"
}
