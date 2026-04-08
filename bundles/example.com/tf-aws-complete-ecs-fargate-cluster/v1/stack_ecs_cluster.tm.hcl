define bundle stack "ecs-cluster" {
  metadata {
    path = "/stacks/${bundle.environment.id}/${bundle.input.region.value.export.account_alias_slug.value}/${bundle.input.region.value.export.region_slug.value}/fargate-clusters/${tm_slug(bundle.input.name.value)}/cluster"

    name        = "AWS ECS Fargate Cluster ${bundle.input.name.value}"
    description = <<-EOF
      AWS ECS Fargate Cluster ${bundle.input.name.value}
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/ecs-cluster",
      # "${bundle.class}/ecs-cluster/${bundle.alias}",
      "${bundle.class}/ecs-cluster/${tm_join("-", [tm_slug(bundle.input.name.value), bundle.environment.id])}",

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
      # cluster_name = bundle.alias
      cluster_name = tm_join("-", [tm_slug(bundle.input.name.value), bundle.environment.id])
      bundle_uuid  = bundle.uuid
      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
        # "${bundle.class}/bundle-alias"  = bundle.alias
        "${bundle.class}/bundle-alias" = tm_slug(bundle.input.name.value)
        "${bundle.class}/environment"  = bundle.environment.id
      }
    }
  }
}
