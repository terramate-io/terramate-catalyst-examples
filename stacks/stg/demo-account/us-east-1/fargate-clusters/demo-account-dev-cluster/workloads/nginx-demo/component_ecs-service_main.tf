// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "ecs_service" {
  assign_public_ip = false
  cluster_arn      = data.aws_ecs_cluster.cluster.arn
  container_definitions = {
    nginx = {
      cpu       = 1024
      essential = true
      image     = "nginx:latest"
      memory    = 4096
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          name          = "nginx"
          protocol      = "tcp"
        },
      ]
      readonlyRootFilesystem = false
    }
  }
  cpu                      = 1024
  deployment_configuration = null
  enable_execute_command   = true
  load_balancer = {
    service = {
      target_group_arn = data.aws_lb_target_group.group.arn
      container_name   = "nginx"
      container_port   = 80
    }
  }
  memory = 4096
  name   = "demo-account-dev-cluster-nginx-demo"
  security_group_egress_rules = {
    all = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }
  security_group_ingress_rules = merge({}, {
    alb = {
      description                  = "Service port"
      from_port                    = 80
      ip_protocol                  = "tcp"
      referenced_security_group_id = tolist(data.aws_lb.alb.security_groups)[0]
    }
  })
  service_connect_configuration = null
  service_tags                  = {}
  source                        = "terraform-aws-modules/ecs/aws//modules/service"
  subnet_ids                    = data.aws_subnets.private.ids
  tags = {
    "example.com/tf-aws-ecs-fargate-service/v1/bundle-alias" = "demo-account-dev-cluster-nginx-demo"
    "example.com/tf-aws-ecs-fargate-service/v1/bundle-uuid"  = "f8e76b96-18d4-40a3-8532-3f0f09daa001"
    "example.com/tf-aws-ecs-fargate-service/v1/environment"  = "stg"
  }
  version = "6.1.0"
}
