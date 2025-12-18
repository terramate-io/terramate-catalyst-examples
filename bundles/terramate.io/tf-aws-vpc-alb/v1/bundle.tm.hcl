define bundle metadata {
  class   = "example.io/tf-aws-vpc-alb/v1"
  version = "1.0.0"

  name         = "VPC and ALB"
  description  = <<EOF
    This Bundle creates and manages a VPC with public and private subnets, NAT gateway,
    and an Application Load Balancer infrastructure. The ALB is configured with a basic
    HTTP listener, but target groups and routing rules should be added when deploying services.
  EOF
  technologies = ["terraform", "opentofu"]
}

define bundle {
  alias = tm_slug(bundle.input.name.value)

  input "env" {
    type                  = string
    prompt                = "Environment"
    description           = "Environment to create the resources in."
    allowed_values        = global.environments
    required_for_scaffold = true
    multiselect           = false
  }

  input "name" {
    type                  = string
    prompt                = "Resource Name"
    description           = "Base name for VPC and ALB resources"
    required_for_scaffold = true
  }

  input "vpc_cidr" {
    type        = string
    prompt      = "VPC CIDR Block"
    description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"
    default     = "10.0.0.0/16"
  }
}

define bundle {
  scaffolding {
    path = "/stacks/${bundle.input.env.value}/vpc-alb/_bundle_vpc_alb_${tm_slug(bundle.input.name.value)}.tm.hcl"
    name = tm_slug(bundle.input.name.value)
  }
}

define bundle stack "vpc" {
  metadata {
    path = "${tm_slug(bundle.input.name.value)}/${tm_slug(bundle.input.name.value)}-vpc"

    name        = "AWS VPC ${bundle.input.name.value}"
    description = <<EOF
      AWS VPC ${bundle.input.name.value} with public and private subnets
    EOF

    tags = [
      "example.io/aws-vpc",
      "example.io/bundle/${bundle.uuid}",
      "example.io/aws-vpc/${bundle.uuid}",
      "example.io/aws-vpc/${tm_slug(bundle.input.name.value)}",
    ]
  }

  component "vpc" {
    source = "/components/example.io/terramate-aws-vpc/v1"
    inputs = {
      name = bundle.input.name.value
      cidr = bundle.input.vpc_cidr.value
      tags = {
        "example.io/bundle-uuid" = bundle.uuid
      }
    }
  }
}

define bundle stack "alb" {
  metadata {
    path = "${tm_slug(bundle.input.name.value)}/${tm_slug(bundle.input.name.value)}-alb"

    name        = "AWS ALB ${bundle.input.name.value}"
    description = <<EOF
      AWS Application Load Balancer ${bundle.input.name.value}
    EOF

    tags = [
      "example.io/aws-alb",
      "example.io/bundle/${bundle.uuid}",
      "example.io/aws-alb/${bundle.uuid}",
      "example.io/aws-alb/${tm_slug(bundle.input.name.value)}",
    ]

    after = [
      "tag:example.io/aws-vpc/${bundle.uuid}"
    ]
  }

  component "alb" {
    source = "/components/example.io/terramate-aws-alb/v1"
    inputs = {
      name = bundle.input.name.value

      # Use filter tags to look up VPC via AWS data sources
      # The component will automatically find the VPC and subnets by bundle UUID tag
      vpc_filter_tags = {
        "example.io/bundle-uuid" = bundle.uuid
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
        "example.io/bundle-uuid" = bundle.uuid
      }
    }
  }
}
