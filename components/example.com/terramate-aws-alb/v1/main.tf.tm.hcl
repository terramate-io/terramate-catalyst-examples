generate_hcl "main.tf" {
  lets {
    alb_bundle_uuid = tm_try(component.input.tags.value["example.com/bundle-uuid"], null)

    # ECS service bundles that target this ALB (by bundle uuid)
    ecs_service_bundles = [
      for svc in tm_bundles("example.com/tf-aws-ecs-fargate-service/v1") :
      svc if tm_try(svc.inputs.alb_bundle_uuid.value, "") == let.alb_bundle_uuid
    ]
  }

  content {
    # Look up VPC via AWS data sources by tags (VPC shares the ALB bundle UUID tag)
    data "aws_vpc" "vpc_by_tags" {
      dynamic "filter" {
        for_each = component.input.vpc_filter_tags.value
        content {
          name   = "tag:${filter.key}"
          values = [filter.value]
        }
      }
    }

    # Get public subnets in the VPC (ALBs must be in public subnets)
    data "aws_subnets" "public" {
      filter {
        name   = "vpc-id"
        values = [data.aws_vpc.vpc_by_tags.id]
      }

      filter {
        name   = "tag:Name"
        values = ["*-public-*"]
      }
    }

    locals {
      # Core networking values
      vpc_id_value         = data.aws_vpc.vpc_by_tags.id
      subnets_value        = data.aws_subnets.public.ids
      vpc_cidr_block_value = data.aws_vpc.vpc_by_tags.cidr_block

      # Ensure egress rules have cidr_ipv4 set - fallback to VPC CIDR
      security_group_egress_rules = {
        for k, v in component.input.security_group_egress_rules.value : k => merge(v, {
          cidr_ipv4 = v.cidr_ipv4 != null ? v.cidr_ipv4 : local.vpc_cidr_block_value
        })
      }
    }

    module "alb" {
      source  = "terraform-aws-modules/alb/aws"
      version = "10.4.0"

      name = component.input.name.value

      load_balancer_type = component.input.load_balancer_type.value

      vpc_id  = local.vpc_id_value
      subnets = local.subnets_value

      enable_deletion_protection = component.input.enable_deletion_protection.value

      # Security Group
      security_group_ingress_rules = component.input.security_group_ingress_rules.value
      security_group_egress_rules  = local.security_group_egress_rules

      # Keep listeners configurable via component input (default HTTP listener is provided by bundle)
      listeners = component.input.listeners.value
      # Target groups will be generated dynamically per ECS service (see separate generate_hcl)
      target_groups = component.input.target_groups.value

      tags = component.input.tags.value
    }

    # No separate ALB data source needed; use module outputs instead

    # Outputs for reference by other components/bundles
    output "security_group_id" {
      description = "Security group ID of the ALB"
      value       = module.alb.security_group_id
    }

    output "target_groups" {
      description = "Map of target groups created by the ALB module (not the dynamically generated ones)"
      value       = module.alb.target_groups
    }

    output "dns_name" {
      description = "DNS name of the ALB"
      value       = module.alb.dns_name
    }

    output "arn" {
      description = "ARN of the ALB"
      value       = module.alb.arn
    }

    output "service_urls" {
      description = "Map of service URLs keyed by service bundle UUID"
      value = {
        for svc in let.ecs_service_bundles : svc.uuid => "http://${module.alb.dns_name}${svc.inputs.path_pattern.value}"
      }
    }
  }
}

# Dynamically create a target group per ECS service that references this ALB
generate_hcl "service-target-groups.tf" {
  lets {
    alb_bundle_uuid = tm_try(component.input.tags.value["example.com/bundle-uuid"], null)
    ecs_service_bundles = [
      for svc in tm_bundles("example.com/tf-aws-ecs-fargate-service/v1") :
      svc if tm_try(svc.inputs.alb_bundle_uuid.value, "") == let.alb_bundle_uuid
    ]
    # Map service UUIDs to their sanitized resource names for cross-referencing
    target_group_refs = {
      for svc in let.ecs_service_bundles : svc.uuid => tm_replace(tm_slug(svc.inputs.service_name.value), "-", "_")
    }
  }

  content {
    # Stable ordering for rule priorities
    locals {
      service_ids = sort([for s in let.ecs_service_bundles : s.uuid])
    }

    # One target group per service; deterministic name so services can look it up by name
    tm_dynamic "resource" {
      for_each = { for s in let.ecs_service_bundles : s.uuid => s }
      # Use replace to convert hyphens to underscores for valid Terraform resource identifiers
      labels = ["aws_lb_target_group", tm_replace(tm_slug(resource.value.inputs.service_name.value), "-", "_")]

      attributes = {
        # Deterministic name: "<alb-name>-<service-name>-<target_group_key>" stripped of dashes and truncated to 32 chars
        # Include service name to ensure uniqueness when multiple services use the same target_group_key
        name        = substr(tm_replace("${component.input.name.value}-${tm_slug(resource.value.inputs.service_name.value)}-${resource.value.inputs.target_group_key.value}", "-", ""), 0, 32)
        port        = resource.value.inputs.container_port.value
        protocol    = "HTTP"
        vpc_id      = local.vpc_id_value
        target_type = "ip"

        deregistration_delay = 30

        tags = merge(
          component.input.tags.value,
          {
            # Helpful tags for discovery and traceability
            "example.com/target-group-for-bundle-uuid" = resource.key
            "Name"                                     = "${component.input.name.value}-${resource.value.inputs.target_group_key.value}"
          }
        )
      }

      content {
        health_check {
          enabled             = true
          healthy_threshold   = 2
          unhealthy_threshold = 2
          timeout             = 5
          interval            = 30
          path                = tm_replace(resource.value.inputs.path_pattern.value, "*", "")
          matcher             = "200"
          protocol            = "HTTP"
          port                = "traffic-port"
        }

        lifecycle {
          create_before_destroy = true
        }
      }
    }

    # One listener rule per service with path-based routing and stable priority
    tm_dynamic "resource" {
      for_each = { for s in let.ecs_service_bundles : s.uuid => s }
      labels   = ["aws_lb_listener_rule", tm_replace(tm_slug(resource.value.inputs.service_name.value), "-", "_")]

      attributes = {
        listener_arn = module.alb.listeners["http"].arn
        priority     = 100 + index(local.service_ids, resource.key)
      }

      content {
        action {
          type             = "forward"
          target_group_arn = tm_hcl_expression(tm_format("aws_lb_target_group.%s.arn", let.target_group_refs[resource.key]))
        }

        condition {
          path_pattern {
            values = [resource.value.inputs.path_pattern.value]
          }
        }
      }
    }
  }
}

