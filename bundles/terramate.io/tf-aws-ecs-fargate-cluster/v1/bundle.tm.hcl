define bundle metadata {
  class   = "example.io/tf-aws-ecs-fargate-cluster/v1"
  version = "1.0.0"

  name         = "ECS Fargate Cluster"
  description  = <<EOF
    This Bundle creates and manages an ECS Fargate cluster on AWS with a default capacity provider strategy
    that balances cost savings (Fargate Spot) with reliability (Fargate on-demand).
  EOF
  technologies = ["terraform", "opentofu"]
}

define bundle {
  alias = tm_slug(bundle.input.cluster_name.value)

  input "env" {
    type                  = string
    prompt                = "Environment"
    description           = "A list of available environments to create the ECS cluster in."
    allowed_values        = global.environments
    required_for_scaffold = true
    multiselect           = false
  }

  input "cluster_name" {
    type                  = string
    prompt                = "ECS Cluster Name"
    description           = "The name of the ECS Fargate cluster"
    required_for_scaffold = true
  }
}

define bundle {
  scaffolding {
    path = "/stacks/${bundle.input.env.value}/ecs/_bundle_ecs_${tm_slug(bundle.input.cluster_name.value)}.tm.hcl"
    name = tm_slug(bundle.input.cluster_name.value)
  }
}

define bundle stack "ecs-cluster" {
  metadata {
    path = tm_slug(bundle.input.cluster_name.value)

    name        = "AWS ECS Fargate Cluster ${bundle.input.cluster_name.value}"
    description = <<EOF
      AWS ECS Fargate Cluster ${bundle.input.cluster_name.value}
    EOF

    tags = [
      "example.io/aws-ecs-cluster",
      "example.io/bundle/${bundle.uuid}",
      "example.io/aws-ecs-cluster/${bundle.uuid}",
      "example.io/aws-ecs-cluster/${tm_slug(bundle.input.cluster_name.value)}",
    ]
  }

  component "ecs-cluster" {
    source = "/components/example.io/terramate-aws-ecs-cluster/v1"

    inputs = {
      cluster_name = bundle.input.cluster_name.value
      bundle_uuid  = bundle.uuid
      tags = {
        "example.io/bundle-uuid" = bundle.uuid
      }
    }
  }
}

define bundle export "cluster_name" {
  value = bundle.input.cluster_name.value
}
