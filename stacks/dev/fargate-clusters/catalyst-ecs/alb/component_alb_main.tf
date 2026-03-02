// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "null_resource" "initial_deployment_trigger" {
}
data "aws_vpc" "vpc_by_tags" {
  depends_on = [
    null_resource.initial_deployment_trigger,
  ]
  filter {
    name = "tag:example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"
    values = [
      "adccd7be-c2fe-4571-9a2c-b0c5b446956a",
    ]
  }
}
data "aws_subnets" "public" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc_by_tags.id,
    ]
  }
  filter {
    name = "tag:Name"
    values = [
      "*-public-*",
    ]
  }
}
locals {
  security_group_egress_rules = { for k, v in {
    all = {
      cidr_ipv4   = "10.0.0.0/16"
      ip_protocol = "-1"
    }
    } : k => merge(v, {
      cidr_ipv4 = v.cidr_ipv4 != null ? v.cidr_ipv4 : local.vpc_cidr_block_value
  }) }
  subnets_value        = data.aws_subnets.public.ids
  vpc_cidr_block_value = data.aws_vpc.vpc_by_tags.cidr_block
  vpc_id_value         = data.aws_vpc.vpc_by_tags.id
}
module "alb" {
  enable_deletion_protection = false
  listeners = {
    http = {
      fixed_response = {
        content_type = "text/plain"
        status_code  = "200"
      }
      port     = 80
      protocol = "HTTP"
      rules = {
        catalyst-ecs-catalyst-nginx = {
          actions = [
            {
              forward = {
                target_group_key = "catalyst-ecs-catalyst-nginx"
              }
            },
          ]
          conditions = [
            {
              path_pattern = {
                values = [
                  "/nginx",
                ]
              }
            },
          ]
          priority = 5000
        }
      }
    }
  }
  load_balancer_type = "application"
  name               = "catalyst-ecs-dev"
  security_group_egress_rules = {
    all = {
      cidr_ipv4   = "10.0.0.0/16"
      ip_protocol = "-1"
    }
  }
  security_group_ingress_rules = {
    all_http = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
    }
  }
  source  = "terraform-aws-modules/alb/aws"
  subnets = local.subnets_value
  tags = {
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "catalyst-ecs"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "adccd7be-c2fe-4571-9a2c-b0c5b446956a"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "dev"
  }
  target_groups = {
    catalyst-ecs-catalyst-nginx = {
      create_attachment    = false
      deregistration_delay = 30
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200"
        path                = "/nginx"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
      name        = "catalyst-ecs-catalyst-nginx"
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
    }
  }
  version = "10.4.0"
  vpc_id  = local.vpc_id_value
}
