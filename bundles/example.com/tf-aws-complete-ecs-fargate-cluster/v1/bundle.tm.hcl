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
  alias = bundle.let.name_slug

  environments {
    required = true
  }

  scaffolding {
    path = "/configs/fargate-clusters/${bundle.let.name_slug}/cluster.tm.yml"
    name = bundle.let.name_slug
  }
}
