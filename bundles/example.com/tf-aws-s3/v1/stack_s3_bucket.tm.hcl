define bundle stack "s3-bucket" {
  metadata {
    path = bundle.let.path_prefix

    name        = "AWS S3 Bucket ${bundle.let.bucket_name}"
    description = <<-EOF
      This stack manages an AWS S3 Bucket named ${bundle.let.bucket_name}
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
      name = bundle.let.bucket_name

      acl = bundle.input.visibility.value

      tags = {
        "${bundle.class}/bundle-uuid" = bundle.uuid
        "${bundle.class}/environment" = bundle.environment.id
      }

      terraform_modules = {
        "terraform-aws-modules/s3-bucket/aws" = {
          source = tm_try(
            bundle.input.terraform_modules.value["terraform-aws-modules/s3-bucket/aws"].source,
            "terraform-aws-modules/s3-bucket/aws"
          )
          version = tm_try(
            bundle.input.terraform_modules.value["terraform-aws-modules/s3-bucket/aws"].version,
            "5.9.1"
          )
        }
      }
    }
  }
}
