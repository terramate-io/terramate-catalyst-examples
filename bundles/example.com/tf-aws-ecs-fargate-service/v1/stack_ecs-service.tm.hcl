define bundle stack "ecs-service" {
  metadata {
    path = "/stacks/${bundle.environment.id}/${tm_split("/", bundle.input.region.value)[0]}/${tm_split("/", bundle.input.region.value)[1]}/fargate-clusters/${bundle.input.cluster_slug.value}/workloads/${tm_slug(bundle.input.service_name.value)}"

    name        = "AWS ECS Fargate Service ${bundle.input.service_name.value}"
    description = <<-EOF
      ECS Fargate service ${bundle.input.service_name.value} attached to existing cluster
    EOF

    tags = [
      bundle.class,
      "environment/${bundle.environment.id}",

      # configure aws and null provider for this stack
      "terraform/provider/aws",
      "terraform/provider/null",
    ]

    after = [
      # "example.com/tf-aws-complete-ecs-fargate-cluster/v1/ecs-cluster/${tm_bundle("example.com/tf-aws-complete-ecs-fargate-cluster/v1", bundle.input.cluster_slug.value).alias}",
      "tag:example.com/tf-aws-complete-ecs-fargate-cluster/v1/ecs-cluster",
      "tag:example.com/tf-aws-complete-ecs-fargate-cluster/v1/alb",
      "tag:example.com/tf-aws-complete-ecs-fargate-cluster/v1/vcs",
    ]
  }

  component "ecs-service" {
    source = "/components/example.com/terramate-aws-ecs-service/v1"

    inputs {
      # name         = bundle.alias
      name         = tm_join("-", [bundle.input.cluster_slug.value, tm_slug(bundle.input.service_name.value)])
      cluster_name = tm_join("-", [bundle.input.cluster_slug.value, bundle.environment.id])

      # VPC is derived from the ALB bundle (they share the same UUID in the VPC-ALB bundle)
      vpc_filter_tags = {
        "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid" = tm_bundle("example.com/tf-aws-complete-ecs-fargate-cluster/v1", bundle.input.cluster_slug.value, bundle.environment.id).uuid
      }

      alb_filter_tags = {
        "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid" = tm_bundle("example.com/tf-aws-complete-ecs-fargate-cluster/v1", bundle.input.cluster_slug.value, bundle.environment.id).uuid
      }

      alb_name          = tm_join("-", [tm_bundle("example.com/tf-aws-complete-ecs-fargate-cluster/v1", bundle.input.cluster_slug.value, bundle.environment.id).export.alb_name.value, bundle.environment.id])
      target_group_name = tm_substr(tm_join("-", [bundle.input.cluster_slug.value, tm_slug(bundle.input.service_name.value)]), 0, 32)

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
        "${bundle.class}/bundle-uuid" = bundle.uuid
        # "${bundle.class}/bundle-alias" = bundle.alias
        "${bundle.class}/bundle-alias" = tm_join("-", [bundle.input.cluster_slug.value, tm_slug(bundle.input.service_name.value)])
        "${bundle.class}/environment"  = bundle.environment.id
      }
    }
  }
}
