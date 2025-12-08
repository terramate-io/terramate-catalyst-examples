define component metadata {
  class        = "components/terramate.io/terramate-aws-alb"
  version      = "1.0.0"
  name         = "terramate-aws-alb"
  description  = "Component that allows creating an Application Load Balancer on AWS."
  technologies = ["terraform", "opentofu"]
}

define component {
  input "name" {
    type        = string
    description = "Name of the ALB"
  }

  input "vpc_filter_tags" {
    type        = map(string)
    description = "Map of tag key-value pairs to filter VPC via AWS data sources (e.g., {\"terramate.io/bundle-uuid\" = \"...\"})"
    default     = {}
  }

  input "load_balancer_type" {
    type        = string
    description = "Type of load balancer"
    default     = "application"
  }

  input "enable_deletion_protection" {
    type        = bool
    description = "Enable deletion protection for the load balancer"
    default     = false
  }

  input "listeners" {
    type        = map(any)
    description = "Map of listener configurations"
    default     = {}
  }

  input "target_groups" {
    type        = map(any)
    description = "Map of target group configurations"
    default     = {}
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

  input "tags" {
    type        = map(string)
    description = "Tags to apply to resources"
    default     = {}
  }
}
