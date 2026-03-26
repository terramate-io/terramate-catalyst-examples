define bundle stack "s3-bucket" {
  metadata {
    path = "/stacks/${bundle.environment.id}/${tm_split("/", bundle.input.region.value)[0]}/${tm_split("/", bundle.input.region.value)[1]}/s3-buckets/${tm_slug(bundle.input.name.value)}-${bundle.environment.id}"

    name        = "AWS S3 Bucket ${bundle.input.name.value}-${bundle.environment.id}"
    description = <<-EOF
      This stack manages an AWS S3 Bucket named ${bundle.input.name.value}-${bundle.environment.id}
      for the ${bundle.environment.name} environment.
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/s3-bucket",
      "environment/${bundle.environment.id}",

      # configure aws provider for this stack
      "terraform/provider/aws",
    ]
  }

  component "s3-bucket" {
    source = "/components/example.com/terramate-aws-s3-bucket/v1"

    inputs {
      # Terramate Note (Environment Example Explanation):
      #
      # The component does not add any suffix to the name, but this bundle manages multiple environments and thus
      # suffixes the buckets automatically
      name = "${bundle.input.name.value}-${bundle.environment.id}"

      acl = bundle.input.visibility.value

      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
        "${bundle.class}/environment" = bundle.environment.id
      }

      terraform_modules = {
        "terraform-aws-modules/s3-bucket/aws" = {
          source = tm_try(
            bundle.input.terraform_modules.value["terraform-aws-modules/s3-bucket/aws"].source,
            # # support for default will be added in future versions
            # bundle.input.terraform_modules.default["terraform-aws-modules/s3-bucket/aws"].source,
            "terraform-aws-modules/s3-bucket/aws"
          )
          version = tm_try(
            bundle.input.terraform_modules.value["terraform-aws-modules/s3-bucket/aws"].version,
            # # support for default will be added in future versions
            # bundle.input.terraform_modules.default["terraform-aws-modules/s3-bucket/aws"].version,
            "5.9.1"
          )
        }
      }
    }
  }
}
