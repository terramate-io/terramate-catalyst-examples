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
      "2cfe746a-f0ee-4ead-af0b-21705419b2a5",
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
      rules    = {}
    }
  }
  load_balancer_type = "application"
  name               = "dev-cluster-dev"
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
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-alias" = "dev-cluster-dev"
    "example.com/tf-aws-complete-ecs-fargate-cluster/v1/bundle-uuid"  = "2cfe746a-f0ee-4ead-af0b-21705419b2a5"
  }
  target_groups = {}
  version       = "10.4.0"
  vpc_id        = local.vpc_id_value
}
