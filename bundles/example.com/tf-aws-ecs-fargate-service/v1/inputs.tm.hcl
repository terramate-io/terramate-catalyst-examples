define bundle {
  input "service_name" {
    type        = string
    description = "Name of the ECS Fargate service"

    prompt {
      text = "Service Name"
    }
  }

  input "cluster_slug" {
    type        = string
    description = "Bundle alias of the ECS cluster to attach this service to"

    prompt {
      text = "Elastic Container Service (ECS) Cluster"
      options = [
        for cluster in tm_bundles("example.com/tf-aws-complete-ecs-fargate-cluster/v1") :
        { name = "${cluster.input.name.value} (${cluster.export.alias.value}) [${cluster.input.region.value}]", value = cluster.export.alias.value }
      ]
    }
  }

  input "region" {
    type        = string
    description = "The account-region combination (account_alias/region). Must match the selected cluster's region. Set automatically based on cluster selection."

    prompt {
      text = "Account / Region (must match the selected cluster)"
      options = [
        for cluster in tm_bundles("example.com/tf-aws-complete-ecs-fargate-cluster/v1") :
        { name = "${cluster.input.name.value} - ${cluster.input.region.value}", value = cluster.export.region_ref.value }
      ]
    }
  }

  input "container_name" {
    type        = string
    description = "Name of the main container"
    default     = "app"

    prompt {
      text = "Container Name"
    }
  }

  input "container_port" {
    type        = number
    description = "Port that containers will listen on"
    default     = 3000

    prompt {
      text = "Container Port"
    }
  }

  input "container_image" {
    type        = string
    description = "Docker image URI for the main container"

    prompt {
      text = "Container Image"
    }
  }

  input "cpu" {
    type        = number
    description = "CPU units for the task (1024 = 1 vCPU)"
    default     = 1024

    prompt {
      text = "CPU Units"
    }
  }

  input "memory" {
    type        = number
    description = "Memory for the task in MB"
    default     = 4096

    prompt {
      text = "Memory (MB)"
    }
  }

  input "target_group_key" {
    type        = string
    description = "Key/name of the target group in the ALB (e.g., 'http', 'ex_ecs')"
    default     = "http"
  }

  input "path_pattern" {
    type        = string
    description = "Path pattern on the ALB listener to route to this service (e.g., /api/*)"
    default     = "/${tm_slug(bundle.input.service_name.value)}/*"

    prompt {
      text = "Listener path pattern"
    }
  }
}
