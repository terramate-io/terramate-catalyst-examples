define bundle metadata {
  class   = "terramate.io/tf-aws-ecs-fargate-service/v1"
  version = "1.0.0"

  name         = "ECS Fargate Service"
  description  = <<EOF
    This Bundle creates and manages an ECS Fargate service that can be attached to existing
    ECS clusters, VPCs, and Application Load Balancers. It uses filter tags to discover
    and reference existing infrastructure resources via AWS data sources.
  EOF
  technologies = ["terraform", "opentofu"]
}

define bundle {
  alias = tm_slug(bundle.input.service_name.value)

  input "env" {
    type                  = string
    prompt                = "Environment"
    description           = "Environment to create the service in."
    allowed_values        = global.environments
    required_for_scaffold = true
    multiselect           = false
  }

  input "service_name" {
    type                  = string
    prompt                = "Service Name"
    description           = "Name of the ECS Fargate service"
    required_for_scaffold = true
  }

  input "cluster_bundle_uuid" {
    type                  = string
    description           = "Bundle UUID of the ECS cluster to attach this service to"
    required_for_scaffold = true
    allowed_values = [for cluster in tm_bundles("terramate.io/tf-aws-ecs-fargate-cluster/v1") :
      { name = "${cluster.inputs.cluster_name.value} (${cluster.uuid})", value = cluster.uuid }
    ]
    prompt = "ECS Cluster Bundle UUID"
  }

  input "vpc_bundle_uuid" {
    type                  = string
    description           = "Bundle UUID of the VPC to use for this service"
    required_for_scaffold = true
    allowed_values = tm_concat(
      [for vpc in tm_bundles("terramate.io/tf-aws-vpc-alb/v1") :
        { name = "${vpc.inputs.name.value} (${vpc.uuid})", value = vpc.uuid }
      ]
    )
    prompt = "VPC Bundle UUID"
  }

  input "alb_bundle_uuid" {
    type                  = string
    description           = "Bundle UUID of the ALB to attach this service to"
    required_for_scaffold = true
    allowed_values = tm_concat(
      [for alb in tm_bundles("terramate.io/tf-aws-vpc-alb/v1") :
        { name = "${alb.inputs.name.value} (${alb.uuid})", value = alb.uuid }
      ]
    )
    prompt = "ALB Bundle UUID"
  }

  input "container_name" {
    type        = string
    prompt      = "Container Name"
    description = "Name of the main container"
    default     = "app"
  }

  input "container_port" {
    type        = number
    prompt      = "Container Port"
    description = "Port that containers will listen on"
    default     = 3000
  }

  input "container_image" {
    type                  = string
    prompt                = "Container Image"
    description           = "Docker image URI for the main container"
    required_for_scaffold = true
  }

  input "cpu" {
    type        = number
    prompt      = "CPU Units"
    description = "CPU units for the task (1024 = 1 vCPU)"
    default     = 1024
  }

  input "memory" {
    type        = number
    prompt      = "Memory (MB)"
    description = "Memory for the task in MB"
    default     = 4096
  }

  input "target_group_key" {
    type        = string
    description = "Key/name of the target group in the ALB (e.g., 'http', 'ex_ecs')"
    default     = "http"
  }
}

define bundle {
  scaffolding {
    path = "/stacks/${bundle.input.env.value}/ecs/_bundle_ecs_service_${tm_slug(bundle.input.service_name.value)}.tm.hcl"
    name = tm_slug(bundle.input.service_name.value)
  }
}

define bundle stack "ecs-service" {
  metadata {
    path = tm_slug(bundle.input.service_name.value)

    name        = "AWS ECS Fargate Service ${bundle.input.service_name.value}"
    description = <<EOF
      ECS Fargate service ${bundle.input.service_name.value} attached to existing cluster
    EOF

    tags = [
      "terramate.io/aws-ecs-service",
      "terramate.io/bundle/${bundle.uuid}",
      "terramate.io/aws-ecs-service/${bundle.uuid}",
      "terramate.io/aws-ecs-service/${tm_slug(bundle.input.service_name.value)}",
    ]

    after = [
      "tag:terramate.io/aws-ecs-cluster/${bundle.input.cluster_bundle_uuid.value}",
      "tag:terramate.io/aws-vpc/${bundle.input.vpc_bundle_uuid.value}",
      "tag:terramate.io/aws-alb/${bundle.input.alb_bundle_uuid.value}",
    ]
  }

  component "ecs-service" {
    source = "/components/terramate.io/terramate-aws-ecs-service/v1"
    inputs = {
      name = bundle.input.service_name.value
      cluster_name = tm_one([for cluster in tm_bundles("terramate.io/tf-aws-ecs-fargate-cluster/v1") :
        cluster.inputs.cluster_name.value if cluster.uuid == bundle.input.cluster_bundle_uuid.value
      ])
      vpc_filter_tags = {
        "terramate.io/bundle-uuid" = bundle.input.vpc_bundle_uuid.value
      }
      alb_filter_tags = {
        "terramate.io/bundle-uuid" = bundle.input.alb_bundle_uuid.value
      }
      target_group_key = bundle.input.target_group_key.value
      cpu              = bundle.input.cpu.value
      memory           = bundle.input.memory.value
      container_name   = bundle.input.container_name.value
      container_port   = bundle.input.container_port.value

      # Container definitions
      container_definitions = {
        (bundle.input.container_name.value) = {
          cpu       = bundle.input.cpu.value / 2
          memory    = bundle.input.memory.value / 2
          essential = true
          image     = bundle.input.container_image.value
          portMappings = [
            {
              name          = bundle.input.container_name.value
              containerPort = bundle.input.container_port.value
              hostPort      = bundle.input.container_port.value
              protocol      = "tcp"
            }
          ]
        }
      }

      enable_execute_command = true

      # Security group egress rules
      security_group_egress_rules = {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }

      tags = {
        "terramate.io/bundle-uuid" = bundle.uuid
      }
    }
  }
}
