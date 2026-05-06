define bundle stack "vpc" {
  metadata {
    path = "/stacks/${bundle.environment.id}/${bundle.input.region.value.export.account_alias_slug.value}/${bundle.input.region.value.export.region_slug.value}/fargate-clusters/${tm_slug(bundle.input.name.value)}/vpc"

    name        = "AWS VPC ${bundle.input.name.value}"
    description = <<-EOF
      AWS VPC ${bundle.input.name.value} with public and private subnets
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/vpc",
      # "${bundle.class}/ecs-cluster/${bundle.alias}",
      "${bundle.class}/ecs-cluster/${tm_slug(bundle.input.name.value)}",

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
      # name = bundle.alias
      name = tm_join("-", [tm_slug(bundle.input.name.value), bundle.environment.id])
      cidr = bundle.input.vpc_cidr.value
      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
        # "${bundle.class}/bundle-alias" = bundle.alias
        "${bundle.class}/bundle-alias" = tm_slug(bundle.input.name.value)
        "${bundle.class}/environment"  = bundle.environment.id
      }
    }
  }
}
