define bundle stack "ecs-service" {
  metadata {
    path = tm_slug(bundle.input.service_name.value)

    name        = "AWS ECS Fargate Service ${bundle.input.service_name.value}"
    description = <<-EOF
      ECS Fargate service ${bundle.input.service_name.value} attached to existing cluster
    EOF

    tags = [
      "example.com/aws-ecs-service",
      "example.com/bundle/${bundle.uuid}",
      "example.com/aws-ecs-service/${bundle.uuid}",
      "example.com/aws-ecs-service/${tm_slug(bundle.input.service_name.value)}",
    ]

    after = [
      "tag:example.com/aws-ecs-cluster/${bundle.input.cluster_bundle_uuid.value}",
      # "tag:example.com/aws-vpc/${bundle.input.alb_bundle_uuid.value}",
      "tag:example.com/aws-alb/${bundle.input.alb_bundle_uuid.value}",
    ]
  }

  component "ecs-service" {
    source = "/components/example.com/terramate-aws-ecs-service/v1"
    inputs = {
      name = bundle.input.service_name.value
      cluster_name = tm_one([for cluster in tm_bundles("example.com/tf-aws-ecs-fargate-cluster/v1") :
        cluster.inputs.cluster_name.value if cluster.uuid == bundle.input.cluster_bundle_uuid.value
      ])
      # VPC is derived from the ALB bundle (they share the same UUID in the VPC-ALB bundle)
      vpc_filter_tags = {
        "example.com/bundle-uuid" = bundle.input.alb_bundle_uuid.value
      }
      alb_filter_tags = {
        "example.com/bundle-uuid" = bundle.input.alb_bundle_uuid.value
      }
      target_group_key = bundle.input.target_group_key.value
      cpu              = bundle.input.cpu.value
      memory           = bundle.input.memory.value
      container_name   = bundle.input.container_name.value
      container_port   = bundle.input.container_port.value

      # Container definitions
      container_definitions = {
        (bundle.input.container_name.value) = {
          cpu       = bundle.input.cpu.value
          memory    = bundle.input.memory.value
          essential = true
          image     = bundle.input.container_image.value
          # Nginx needs write access to /var/cache/nginx for temporary files
          readonlyRootFilesystem = false
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
        "example.com/bundle-uuid" = bundle.uuid
      }
    }
  }
}
