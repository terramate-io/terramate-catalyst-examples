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
