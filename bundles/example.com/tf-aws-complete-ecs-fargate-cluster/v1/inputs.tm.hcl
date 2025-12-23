define bundle {
  input "env" {
    type        = string
    description = "A list of available environments to create the ECS cluster in."

    # scaffolding configuration
    prompt = "Please chose an environment"
    allowed_values = [
      for k, v in global.environments : { name = v, value = k }
    ]
    required_for_scaffold = true
    multiselect           = false
  }

  input "name" {
    type        = string
    description = <<-EOF
		  The name for the ECS Fargate Cluster, Load Balancer, and VPC.
		EOF

    # scaffolding configuration
    prompt                = "Please enter a cluster name"
    required_for_scaffold = true
  }

  input "vpc_cidr" {
    type        = string
    description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"

    # scaffolding configuration
    prompt  = "VPC CIDR Block"
    default = "10.0.0.0/16"
  }

  input "tags" {
    type        = map(string)
    description = "AWS Rersource tags to attach to all created resources. Additional internal tags will be added by default."

  }
}