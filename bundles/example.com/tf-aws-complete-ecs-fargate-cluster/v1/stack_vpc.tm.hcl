define bundle stack "vpc" {
  metadata {
    path = "${bundle.let.path_prefix}/vpc"

    name        = "AWS VPC ${bundle.input.name.value}"
    description = <<-EOF
      AWS VPC ${bundle.input.name.value} with public and private subnets
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/vpc",
      "${bundle.class}/ecs-cluster/${bundle.let.name_slug}",

      # tag the environment
      "environment/${bundle.environment.id}",

      # configure aws and null provider for this stack
      "terraform/provider/aws",
      "terraform/provider/null",
    ]
  }

  component "vpc" {
    source = "/components/example.com/terramate-aws-vpc/v1"
    inputs = {
      name = bundle.let.cluster_name
      cidr = bundle.input.vpc_cidr.value
      tags = {
        "${bundle.class}/bundle-uuid"  = bundle.uuid
        "${bundle.class}/bundle-alias" = bundle.let.name_slug
        "${bundle.class}/environment"  = bundle.environment.id
      }
    }
  }
}
