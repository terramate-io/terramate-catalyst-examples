define bundle {
  input "env" {
    type                  = string
    prompt                = "Environment"
    description           = "Environment to create the resources in."
    allowed_values        = global.environments
    required_for_scaffold = true
    multiselect           = false
  }

  input "name" {
    type                  = string
    prompt                = "Resource Name"
    description           = "Base name for VPC and ALB resources"
    required_for_scaffold = true
  }

  input "vpc_cidr" {
    type        = string
    prompt      = "VPC CIDR Block"
    description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"
    default     = "10.0.0.0/16"
  }
}


