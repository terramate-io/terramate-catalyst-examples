define bundle metadata {
  class   = "example.io/tf-aws-s3/v1"
  version = "1.0.0"

  name         = "S3 Bucket"
  description  = <<EOF
    This Bundle creates and manages a private S3 Bucket on AWS.
  EOF
  technologies = ["terraform", "opentofu"]
}

define bundle {
  alias = tm_slug(bundle.input.name.value)

  input "env" {
    type                  = string
    prompt                = "Environment"
    description           = "A list of available environments to create the S3 bucket in."
    allowed_values        = global.environments
    required_for_scaffold = true
    multiselect           = false
  }

  input "name" {
    type                  = string
    prompt                = "S3 Bucket Name"
    description           = "The name of the S3 bucket"
    required_for_scaffold = true
  }
}

define bundle {
  scaffolding {
    path = "/stacks/${bundle.input.env.value}/s3/_bundle_s3_${tm_slug(bundle.input.name.value)}.tm.hcl"
    name = tm_slug(bundle.input.name.value)
  }
}

define bundle stack "s3-bucket" {
  metadata {
    path = tm_slug(bundle.input.name.value)

    name        = "AWS S3 Bucket ${bundle.input.name.value}"
    description = <<EOF
      AWS S3 Bucket ${bundle.input.name.value}
    EOF

    tags = [
      "example.io/aws-s3-bucket",
      "example.io/bundle/${bundle.uuid}",
      "example.io/aws-s3-bucket/${bundle.uuid}",
      "example.io/aws-s3-bucket/${tm_slug(bundle.input.name.value)}",
    ]
  }

  component "s3-bucket" {
    source = "/components/example.io/terramate-aws-s3-bucket/v1"
    inputs = {
      name        = bundle.input.name.value
      bundle_uuid = bundle.uuid
      tags = {
        "example.io/bundle-uuid" = bundle.uuid
      }
    }
  }
}

