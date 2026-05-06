define bundle {
  input "region" {
    type        = bundle("example.com/region/v1")
    immutable   = true
    description = "The region to deploy this cluster into"

    prompt {
      text = "Account / Region"
    }
  }

  input "name" {
    type        = string
    immutable   = true
    description = <<-EOF
		  The name for the ECS Fargate Cluster, Load Balancer, and VPC.
		EOF

    prompt {
      text = "Please enter a cluster name"
    }
  }

  input "vpc_cidr" {
    type        = string
    description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"

    default = "10.0.0.0/16"

    prompt {
      text = "VPC CIDR Block"
    }
  }

  input "tags" {
    type        = map(string)
    description = "AWS Resource tags to attach to all created resources. Additional internal tags will be added by default."
    default     = {}
  }
}
