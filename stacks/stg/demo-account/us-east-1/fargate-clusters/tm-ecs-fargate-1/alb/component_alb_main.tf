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
      "7b507255-36bc-4f49-aa62-feeb7844975a",
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
      cidr_ipv4   = "10.1.0.0/16"
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
      rules    = {}
    }
  }
  load_balancer_type = "application"
  name               = "tm-ecs-fargate-1-stg"
  security_group_egress_rules = {
    all = {
      cidr_ipv4   = "10.1.0.0/16"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "tm-ecs-fargate-1"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "7b507255-36bc-4f49-aa62-feeb7844975a"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/environment"  = "stg"
  }
  target_groups = {}
  version       = "10.4.0"
  vpc_id        = local.vpc_id_value
}
