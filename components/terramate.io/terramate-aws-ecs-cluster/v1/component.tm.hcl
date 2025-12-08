define component metadata {
  class        = "components/terramate.io/terramate-aws-ecs-cluster"
  version      = "1.0.0"
  name         = "terramate-aws-ecs-cluster"
  description  = "Component that allows creating an ECS cluster on AWS with a default capacity provider strategy."
  technologies = ["terraform", "opentofu"]
}

define component {
  input "cluster_name" {
    type        = string
    description = "Name of the ECS cluster"
  }

  input "tags" {
    type        = map(string)
    description = "Tags to apply to resources"
    default     = {}
  }
}
