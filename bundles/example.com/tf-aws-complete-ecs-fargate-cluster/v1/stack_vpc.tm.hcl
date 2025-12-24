define bundle stack "vpc" {
  metadata {
    path = "/stacks/${bundle.input.env.value}/ecs-clusters/${tm_slug(bundle.input.name.value)}/vpc"

    name        = "AWS VPC ${bundle.input.name.value}"
    description = <<-EOF
      AWS VPC ${bundle.input.name.value} with public and private subnets
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/vpc",
      # "${bundle.class}/ecs-cluster/${bundle.alias}",
      "${bundle.class}/ecs-cluster/${tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])}",
    ]
  }

  component "vpc" {
    source = "/components/example.com/terramate-aws-vpc/v1"
    inputs = {
      # name = bundle.alias
      name = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])
      cidr = bundle.input.vpc_cidr.value
      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
        # "${bundle.class}/bundle-alias"  = bundle.alias
        "${bundle.class}/bundle-alias" = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])
      }
    }
  }
}

