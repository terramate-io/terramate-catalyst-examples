generate_hcl "imports.tf" {
  content {
    # Initial deployment trigger to postpone evaluation of remote data sources
    resource "null_resource" "initial_deployment_trigger" {
    }

    data "aws_ecs_cluster" "cluster" {
      cluster_name = component.input.cluster_name.value

      depends_on = [
        null_resource.initial_deployment_trigger
      ]
    }

    data "aws_vpc" "vpc" {
      tm_dynamic "filter" {
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
        values = [data.aws_vpc.vpc.id]
      }

      filter {
        name   = "tag:Name"
        values = ["*-private-*"]
      }
    }

    data "aws_lb" "alb" {
      name = component.input.alb_name.value

      depends_on = [
        null_resource.initial_deployment_trigger
      ]
    }

    data "aws_lb_target_group" "group" {
      name = component.input.target_group_name.value
      depends_on = [
        null_resource.initial_deployment_trigger
      ]
    }
  }
}
