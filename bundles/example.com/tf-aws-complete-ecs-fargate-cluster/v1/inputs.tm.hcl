define bundle {
  input "name" {
    type        = string
    description = <<-EOF
		  The name for the ECS Fargate Cluster, Load Balancer, and VPC.
		EOF

    # scaffolding configuration
    prompt    = "Please enter a cluster name"
    immutable = true
  }

  input "vpc_cidr" {
    type        = string
    description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"

    # scaffolding configuration
    prompt    = "VPC CIDR Block"
    default   = "10.0.0.0/16"
    immutable = true
  }

  input "tags" {
    type        = map(string)
    description = "AWS Resource tags to attach to all created resources. Additional internal tags will be added by default."
    default     = {}
  }
}
