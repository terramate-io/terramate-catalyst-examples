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
  alias = bundle.let.service_name

  environments {
    required = true
  }

  scaffolding {
    path = "/configs/fargate-clusters/${bundle.let.cluster.alias}/service_${bundle.let.service_slug}.tm.yml"
    name = bundle.let.service_slug
  }
}
