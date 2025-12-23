define bundle {
  input "env" {
    type                  = string
    prompt                = "Environment"
    description           = "A list of available environments to create the ECS cluster in."
    allowed_values        = global.environments
    required_for_scaffold = true
    multiselect           = false
  }

  input "cluster_name" {
    type                  = string
    prompt                = "ECS Cluster Name"
    description           = "The name of the ECS Fargate cluster"
    required_for_scaffold = true
  }
}
