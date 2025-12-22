define bundle stack "ecs-cluster" {
  metadata {
    path = tm_slug(bundle.input.cluster_name.value)

    name        = "AWS ECS Fargate Cluster ${bundle.input.cluster_name.value}"
    description = <<-EOF
      AWS ECS Fargate Cluster ${bundle.input.cluster_name.value}
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/ecs-fargate-cluster",
      # "example.com/aws-ecs-cluster",
      # "example.com/bundle/${bundle.uuid}",
      # "example.com/aws-ecs-cluster/${bundle.uuid}",
      # "example.com/aws-ecs-cluster/${tm_slug(bundle.input.cluster_name.value)}",
    ]
  }

  component "ecs-cluster" {
    source = "/components/example.com/terramate-aws-ecs-cluster/v1"

    inputs = {
      cluster_name = bundle.input.cluster_name.value
      bundle_uuid  = bundle.uuid
      tags = {
        "example.com/bundle-uuid" = bundle.uuid
      }
    }
  }
}
