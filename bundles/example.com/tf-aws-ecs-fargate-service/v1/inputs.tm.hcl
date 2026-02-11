define bundle {
  input "service_name" {
    type        = string
    prompt      = "Service Name"
    description = "Name of the ECS Fargate service"
  }

  input "cluster_slug" {
    type        = string
    description = "Bundle UUID of the ECS cluster to attach this service to"

    # scaffolding configuration
    options = [
      for cluster in tm_bundles("example.com/tf-aws-complete-ecs-fargate-cluster/v1") :
      { name = "${cluster.input.name.value} (${cluster.export.alias.value} / ${cluster.uuid}) [${cluster.environment.id}]", value = cluster.export.alias.value }
    ]
    prompt = "Elastic Container Service (ECS) Cluster"
  }

  input "container_name" {
    type        = string
    prompt      = "Container Name"
    description = "Name of the main container"
    default     = "app"
  }

  input "container_port" {
    type        = number
    prompt      = "Container Port"
    description = "Port that containers will listen on"
    default     = 3000
  }

  input "container_image" {
    type        = string
    prompt      = "Container Image"
    description = "Docker image URI for the main container"
  }

  input "cpu" {
    type        = number
    prompt      = "CPU Units"
    description = "CPU units for the task (1024 = 1 vCPU)"
    default     = 1024
  }

  input "memory" {
    type        = number
    prompt      = "Memory (MB)"
    description = "Memory for the task in MB"
    default     = 4096
  }

  input "target_group_key" {
    type        = string
    description = "Key/name of the target group in the ALB (e.g., 'http', 'ex_ecs')"
    default     = "http"
  }

  input "path_pattern" {
    type        = string
    prompt      = "Listener path pattern"
    description = "Path pattern on the ALB listener to route to this service (e.g., /api/*)"
    default     = "/${tm_slug(bundle.input.service_name.value)}/*"
  }
}
