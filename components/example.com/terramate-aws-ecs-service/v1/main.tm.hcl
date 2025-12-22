generate_hcl "main.tf" {
  content {
    # Initial deployment trigger to postpone evaluation of remote data sources
    resource "null_resource" "initial_deployment_trigger" {
    }

    # Look up ECS cluster by name (ECS clusters don't support tag filtering)
    data "aws_ecs_cluster" "cluster_by_name" {
      cluster_name = component.input.cluster_name.value

      depends_on = [
        null_resource.initial_deployment_trigger
      ]
    }

    # Look up VPC via AWS data sources by tags
    data "aws_vpc" "vpc_by_tags" {
      dynamic "filter" {
        for_each = component.input.vpc_filter_tags.value
        content {
          name   = "tag:${filter.key}"
          values = [filter.value]
        }
      }

      depends_on = [
        null_resource.initial_deployment_trigger
      ]
    }

    # Get private subnets in the VPC (ECS tasks should be in private subnets)
    # Filter by Name tag pattern that includes "-private-" which is how terraform-aws-modules/vpc tags private subnets
    data "aws_subnets" "private" {
      filter {
        name   = "vpc-id"
        values = [data.aws_vpc.vpc_by_tags.id]
      }

      filter {
        name   = "tag:Name"
        values = ["*-private-*"]
      }
    }

    locals {
      # Use AWS data sources to find cluster, VPC and subnets
      cluster_arn_value = data.aws_ecs_cluster.cluster_by_name.arn
      vpc_id_value      = data.aws_vpc.vpc_by_tags.id
      # Use private subnets only (ECS tasks should not be directly exposed to internet)
      subnet_ids_value = data.aws_subnets.private.ids

      # Look up ALB if alb_filter_tags is provided (check if map is not empty)
      # Use the ALB's security_groups attribute to get the security group ID directly
      # This avoids the issue of multiple security groups matching the same bundle UUID tag
      # Note: security_groups is a set, so we convert it to a list and take the first element
      alb_security_group_id_value = tm_length(component.input.alb_filter_tags.value) > 0 ? tm_hcl_expression("tolist(data.aws_lb.alb_by_tags.security_groups)[0]") : null
      target_group_arn_value      = tm_length(component.input.alb_filter_tags.value) > 0 ? tm_hcl_expression("data.aws_lb_target_group.existing.arn") : null

      # Build ALB ingress rule map with known structure to avoid for_each issues
      # Always define the map structure, but conditionally include the "alb" entry
      alb_ingress_rule = tm_length(component.input.alb_filter_tags.value) > 0 ? {
        alb = {
          description                  = "Service port"
          from_port                    = component.input.container_port.value
          ip_protocol                  = "tcp"
          referenced_security_group_id = local.alb_security_group_id_value
        }
      } : {}
    }

    # Look up ALB by tags (only if alb_filter_tags is provided and not empty)
    tm_dynamic "data" {
      labels    = ["aws_lb", "alb_by_tags"]
      condition = tm_length(component.input.alb_filter_tags.value) > 0

      content {
        tags = component.input.alb_filter_tags.value

        depends_on = [
          null_resource.initial_deployment_trigger
        ]
      }
    }

    # Look up the pre-created target group (managed by the ALB component) by deterministic name
    tm_dynamic "data" {
      labels    = ["aws_lb_target_group", "existing"]
      condition = tm_length(component.input.alb_filter_tags.value) > 0

      content {
        # Must match the name created in the ALB component: "<alb-name>-<service-name>-<target_group_key>" (stripped dashes, truncated)
        # Use tm_hcl_expression with tm_format - escape $ to prevent Terramate from parsing it
        name = tm_hcl_expression(tm_format("substr(replace(\"$${data.aws_lb.alb_by_tags.name}-%s-%s\", \"-\", \"\"), 0, 32)", tm_slug(component.input.name.value), component.input.target_group_key.value))
      }
    }

    module "ecs_service" {
      source  = "terraform-aws-modules/ecs/aws//modules/service"
      version = "6.1.0"

      name        = component.input.name.value
      cluster_arn = local.cluster_arn_value

      cpu    = component.input.cpu.value
      memory = component.input.memory.value

      # Enables ECS Exec
      enable_execute_command = component.input.enable_execute_command.value

      # Assign public IP for Fargate tasks (required for pulling images from public registries)
      assign_public_ip = component.input.assign_public_ip.value

      # Blue/green deployment configuration
      deployment_configuration = component.input.deployment_configuration.value

      # Container definition(s)
      container_definitions = component.input.container_definitions.value

      # Service Connect configuration
      service_connect_configuration = component.input.service_connect_configuration.value

      # Load balancer configuration
      load_balancer = local.target_group_arn_value != null ? {
        service = {
          target_group_arn = local.target_group_arn_value
          container_name   = component.input.container_name.value
          container_port   = component.input.container_port.value
        }
      } : null

      subnet_ids = local.subnet_ids_value

      # Security group rules - add ALB security group ingress if alb_bundle_uuid is provided
      # Use the local variable to ensure map structure is known at plan time
      security_group_ingress_rules = merge(
        component.input.security_group_ingress_rules.value,
        local.alb_ingress_rule
      )
      security_group_egress_rules = component.input.security_group_egress_rules.value

      service_tags = component.input.service_tags.value
      tags         = component.input.tags.value
    }
  }
}
