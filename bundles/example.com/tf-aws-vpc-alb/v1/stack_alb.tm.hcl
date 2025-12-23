define bundle stack "alb" {
  metadata {
    path = "${tm_slug(bundle.input.name.value)}/${tm_slug(bundle.input.name.value)}-alb"

    name        = "AWS ALB ${bundle.input.name.value}"
    description = <<-EOF
      AWS Application Load Balancer ${bundle.input.name.value}
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/alb",
      # "${bundle.class}/alb/${bundle.uuid}",
      # "example.com/bundle/${bundle.uuid}",
      # "example.com/aws-alb/${bundle.uuid}",
      # "example.com/aws-alb/${tm_slug(bundle.input.name.value)}",
    ]

    after = [
      "tag:${bundle.class}/vpc",
    ]
  }

  component "alb" {
    source = "/components/example.com/terramate-aws-alb/v1"
    inputs = {
      name = bundle.input.name.value

      # Use filter tags to look up VPC via AWS data sources
      # The component will automatically find the VPC and subnets by bundle UUID tag
      vpc_filter_tags = {
        "example.com/bundle-uuid" = bundle.uuid
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
          # cidr_ipv4 will be automatically set from VPC data source
          cidr_ipv4 = null
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
        }
      }

      # No target groups configured by default - add them when deploying services
      target_groups = {}

      tags = {
        "example.com/bundle-uuid" = bundle.uuid
      }
    }
  }
}
