define bundle stack "vpc" {
  metadata {
    path = "${tm_slug(bundle.input.name.value)}/${tm_slug(bundle.input.name.value)}-vpc"

    name        = "AWS VPC ${bundle.input.name.value}"
    description = <<-EOF
      AWS VPC ${bundle.input.name.value} with public and private subnets
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/vpc",
      # "example.com/aws-vpc",
      # "example.com/bundle/${bundle.uuid}",
      # "example.com/aws-vpc/${bundle.uuid}",
      # "example.com/aws-vpc/${tm_slug(bundle.input.name.value)}",
    ]
  }

  component "vpc" {
    source = "/components/example.com/terramate-aws-vpc/v1"
    inputs = {
      name = bundle.input.name.value
      cidr = bundle.input.vpc_cidr.value
      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
      }
    }
  }
}

