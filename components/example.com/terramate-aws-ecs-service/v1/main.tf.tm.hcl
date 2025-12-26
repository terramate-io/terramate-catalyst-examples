generate_hcl "main.tf" {
  content {
    module "ecs_service" {
      source  = "terraform-aws-modules/ecs/aws//modules/service"
      version = "6.1.0"

      name        = component.input.name.value
      cluster_arn = data.aws_ecs_cluster.cluster.arn

      cpu    = component.input.cpu.value
      memory = component.input.memory.value

      enable_execute_command        = component.input.enable_execute_command.value
      assign_public_ip              = component.input.assign_public_ip.value
      deployment_configuration      = component.input.deployment_configuration.value
      container_definitions         = component.input.container_definitions.value
      service_connect_configuration = component.input.service_connect_configuration.value
      load_balancer = {
        service = {
          target_group_arn = data.aws_lb_target_group.group.arn
          container_name   = component.input.container_name.value
          container_port   = component.input.container_port.value
        }
      }

      subnet_ids = data.aws_subnets.private.ids

      security_group_ingress_rules = merge(
        component.input.security_group_ingress_rules.value,
        {
          alb = {
            description                  = "Service port"
            from_port                    = component.input.container_port.value
            ip_protocol                  = "tcp"
            referenced_security_group_id = tolist(data.aws_lb.alb.security_groups)[0]
          }
        }
      )
      security_group_egress_rules = component.input.security_group_egress_rules.value

      service_tags = component.input.service_tags.value
      tags         = component.input.tags.value
    }
  }
}
