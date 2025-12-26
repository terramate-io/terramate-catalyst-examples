define bundle metadata {
  class   = "example.com/tf-aws-ecs-fargate-service/v1"
  version = "1.0.0"

  name        = "AWS ECS Fargate Service"
  description = <<-EOF
    This Bundle creates and manages an ECS Fargate service that can be attached to existing
    ECS clusters, VPCs, and Application Load Balancers. It uses filter tags to discover
    and reference existing infrastructure resources via AWS data sources.
  EOF
}

define bundle {
  alias = tm_join("-", [bundle.input.cluster_slug.value, tm_slug(bundle.input.service_name.value)])

  scaffolding {
    path = "/cluster-workloads/${bundle.input.cluster_slug.value}/${tm_slug(bundle.input.service_name.value)}.tm.hcl"

    name = tm_slug(bundle.input.service_name.value)

    enabled {
      condition     = tm_length(tm_bundles("example.com/tf-aws-complete-ecs-fargate-cluster/v1")) > 0
      error_message = <<-EOF
        This bundle requires an instance of the AWS ECS Fargate Cluster (example.com/tf-aws-complete-ecs-fargate-cluster/v1) bundle.
      EOF
    }
  }
}
