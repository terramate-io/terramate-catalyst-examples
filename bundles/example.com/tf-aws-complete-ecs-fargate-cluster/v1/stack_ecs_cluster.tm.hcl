define bundle stack "ecs-cluster" {
  metadata {
    path = "/stacks/${bundle.input.env.value}/ecs-clusters/${tm_slug(bundle.input.name.value)}/cluster"

    name        = "AWS ECS Fargate Cluster ${bundle.input.name.value}"
    description = <<-EOF
      AWS ECS Fargate Cluster ${bundle.input.name.value}
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/ecs-cluster",
      # "${bundle.class}/ecs-cluster/${bundle.alias}",
      "${bundle.class}/ecs-cluster/${tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])}",

      # tag the environment
      "environment/${bundle.input.env.value}",

      # configure aws and null provider for this stack
      "terraform/provider/aws",
      "terraform/provider/null",
    ]
  }

  component "ecs-cluster" {
    source = "/components/example.com/terramate-aws-ecs-cluster/v1"

    inputs = {
      # cluster_name = bundle.alias
      cluster_name = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])
      bundle_uuid  = bundle.uuid
      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
        # "${bundle.class}/bundle-alias"  = bundle.alias
        "${bundle.class}/bundle-alias" = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])
      }
    }
  }
}
