define component metadata {
  class        = "components/example.io/terramate-aws-vpc"
  version      = "1.0.0"
  name         = "terramate-aws-vpc"
  description  = "Component that allows creating a VPC on AWS with public and private subnets, NAT gateway, and internet gateway."
  technologies = ["terraform", "opentofu"]
}

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
