define bundle stack "alb" {
  metadata {
    path = "/stacks/${bundle.input.env.value}/ecs-clusters/${tm_slug(bundle.input.name.value)}/alb"

    name        = "AWS ALB ${bundle.input.name.value}"
    description = <<-EOF
      AWS Application Load Balancer ${bundle.input.name.value}
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/alb",
      # "${bundle.class}/ecs-cluster/${bundle.alias}",
      "${bundle.class}/ecs-cluster/${tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])}",
      "example.com/aws-alb/${tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])}",
    ]

    after = [
      "tag:${bundle.class}/vpc",
    ]
  }

  component "alb" {
    source = "/components/example.com/terramate-aws-alb/v1"
    inputs = {
      # name = bundle.alias
      name = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])

      # The component will automatically find the VPC and subnets by bundle UUID tag
      vpc_filter_tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
      }

      load_balancer_type         = "application"
      enable_deletion_protection = false

      # Default security group rules
      security_group_ingress_rules = {
        all_http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }

      security_group_egress_rules = {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = bundle.input.vpc_cidr.value
        }
      }

      # Basic HTTP listener - no routing rules or target groups configured
      # Target groups and listener rules should be added when deploying services
      listeners = {
        http = {
          port     = 80
          protocol = "HTTP"

          # Default response when no target groups are attached
          fixed_response = {
            content_type = "text/plain"
            status_code  = "200"
          }
          rules = {
            for service in tm_bundles("example.com/tf-aws-ecs-fargate-service/v1") :
            service.alias => service.exports.listener_rule.value
          }
        }
      }

      # No target groups configured by default - add them when deploying services
      target_groups = {
        for service in tm_bundles("example.com/tf-aws-ecs-fargate-service/v1") :
        service.alias => service.exports.target_group.value
      }

      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
        # "${bundle.class}/bundle-alias" = bundle.alias
        "${bundle.class}/bundle-alias" = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])
      }
    }
  }
}
