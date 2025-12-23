
define component {
  input "name" {
    type        = string
    description = "Name of the ECS service"
  }

  input "cluster_name" {
    type        = string
    description = "Name of the ECS cluster (used to look up cluster via AWS data sources)"
  }

  input "vpc_filter_tags" {
    type        = map(string)
    description = "Map of tag key-value pairs to filter VPC via AWS data sources (e.g., {\"example.com/bundle-uuid\" = \"...\"})"
    default     = {}
  }

  input "alb_filter_tags" {
    type        = map(string)
    description = "Map of tag key-value pairs to filter ALB via AWS data sources (optional, e.g., {\"example.com/bundle-uuid\" = \"...\"})"
    default     = {}
  }

  input "alb_name" {
    type        = string
    description = "The ALB to attach the service to"
  }

  input "target_group_name" {
    type        = string
    description = "The ALBs target group to attach the service to"
  }


  input "target_group_key" {
    type        = string
    description = "Key/name of the target group in the ALB (e.g., 'http', 'ex_ecs')"
    default     = "http"
  }

  input "cpu" {
    type        = number
    description = "CPU units for the task (1024 = 1 vCPU)"
    default     = 1024
  }

  input "memory" {
    type        = number
    description = "Memory for the task in MB"
    default     = 4096
  }

  input "container_definitions" {
    type        = map(any)
    description = "Map of container definitions"
  }

  input "container_name" {
    type        = string
    description = "Name of the main container (used for load balancer configuration)"
  }

  input "container_port" {
    type        = number
    description = "Port that the container listens on"
  }

  input "enable_execute_command" {
    type        = bool
    description = "Enable ECS Exec for the service"
    default     = true
  }

  input "assign_public_ip" {
    type        = bool
    description = "Assign a public IP address to the ENI (Fargate launch type only). Should be false for private subnets (use NAT Gateway for internet access)."
    default     = false
  }

  input "deployment_configuration" {
    type        = map(any)
    description = "Deployment configuration for blue/green deployments"
    default     = null
  }

  input "service_connect_configuration" {
    type        = map(any)
    description = "Service Connect configuration"
    default     = null
  }

  input "security_group_ingress_rules" {
    type        = map(any)
    description = "Map of security group ingress rules"
    default     = {}
  }

  input "security_group_egress_rules" {
    type        = map(any)
    description = "Map of security group egress rules"
    default     = {}
  }

  input "service_tags" {
    type        = map(string)
    description = "Tags to apply to the service (separate from task definition tags)"
    default     = {}
  }

  input "tags" {
    type        = map(string)
    description = "Tags to apply to resources"
    default     = {}
  }
}
