define bundle metadata {
  class   = "example.com/tf-aws-complete-ecs-fargate-cluster/v1"
  version = "1.0.0"

  name        = "AWS ECS Fargate Cluster (VPC, ALB, ECS Fargate Cluster)"
  description = <<-EOF
    This Bundle creates and manages an ECS Fargate cluster on AWS with a default capacity provider strategy
    that balances cost savings (Fargate Spot) with reliability (Fargate on-demand).

    It provisions 3 stacks including the required dependencies:

    - VPC Stack:
      - AWS Virtual Private Cloud (VPC)
      - private and public networks (Subnets)
      - NAT Gateways

    - ALB Stack:
      - Application Loadbalancer (ALB)
        The ALB will reconfigure itself based on deployed ECS services.

    - ECS Stack:
      - The ECS Fargate Cluster
  EOF
}

define bundle {
  alias = tm_slug(bundle.input.name.value)

  environments {
    required = true
  }

  scaffolding {
    path = "/configs/fargate-clusters/${tm_slug(bundle.input.name.value)}/cluster.tm.yml"
    name = tm_slug(bundle.input.name.value)

    enabled {
      condition     = tm_length(tm_bundles("example.com/region/v1")) > 0
      error_message = <<-EOF
        This bundle requires an instance of the AWS Region (example.com/region/v1) bundle.

        There seems to be no region bundle instance in the selected environment: ${bundle.environment.name} [${bundle.environment.id}]
      EOF
    }
  }
}
