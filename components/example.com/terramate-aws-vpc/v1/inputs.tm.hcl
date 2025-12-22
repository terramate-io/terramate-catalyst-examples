define component {
  input "name" {
    type        = string
    description = "Name of the VPC"
  }

  input "cidr" {
    type        = string
    description = "CIDR block for the VPC"
    default     = "10.0.0.0/16"
  }

  input "enable_nat_gateway" {
    type        = bool
    description = "Enable NAT Gateway for private subnets"
    default     = true
  }

  input "single_nat_gateway" {
    type        = bool
    description = "Use a single NAT Gateway for all private subnets (cost optimization)"
    default     = true
  }

  input "tags" {
    type        = map(string)
    description = "Tags to apply to resources"
    default     = {}
  }
}
