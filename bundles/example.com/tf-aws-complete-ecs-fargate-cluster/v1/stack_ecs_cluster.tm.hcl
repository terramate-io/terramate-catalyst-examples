define bundle stack "ecs-cluster" {
  metadata {
    path = "${bundle.let.path_prefix}/cluster"

    name        = "AWS ECS Fargate Cluster ${bundle.input.name.value}"
    description = <<-EOF
      AWS ECS Fargate Cluster ${bundle.input.name.value}
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/ecs-cluster",
      "${bundle.class}/ecs-cluster/${bundle.let.cluster_name}",

      # tag the environment
      "environment/${bundle.environment.id}",

      # configure aws and null provider for this stack
      "terraform/provider/aws",
      "terraform/provider/null",
    ]
  }

  component "ecs-cluster" {
    source = "/components/example.com/terramate-aws-ecs-cluster/v1"

    inputs = {
      cluster_name = bundle.let.cluster_name
      bundle_uuid  = bundle.uuid
      tags = {
        "${bundle.class}/bundle-uuid"  = bundle.uuid
        "${bundle.class}/bundle-alias" = bundle.let.name_slug
        "${bundle.class}/environment"  = bundle.environment.id
      }
    }
  }
}
