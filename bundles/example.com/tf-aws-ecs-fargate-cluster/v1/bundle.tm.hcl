define bundle metadata {
  class   = "example.com/tf-aws-ecs-fargate-cluster/v1"
  version = "1.0.0"

  name        = "AWS ECS Fargate Cluster"
  description = <<-EOF
    This Bundle creates and manages an ECS Fargate cluster on AWS with a default capacity provider strategy
    that balances cost savings (Fargate Spot) with reliability (Fargate on-demand).
  EOF
}

define bundle {
  alias = tm_slug(bundle.input.cluster_name.value)

  scaffolding {
    path = "/stacks/${bundle.input.env.value}/ecs/_bundle_ecs_${tm_slug(bundle.input.cluster_name.value)}.tm.hcl"
    name = tm_slug(bundle.input.cluster_name.value)
  }
}
