define bundle stack "s3-bucket" {
  metadata {
    path = tm_slug(bundle.input.name.value)

    name        = "AWS S3 Bucket ${bundle.input.name.value}"
    description = <<-EOF
      AWS S3 Bucket ${bundle.input.name.value}
    EOF

    tags = [
      bundle.class,
      "${bundle.class}/s3-bcuket",
    ]
  }

  component "s3-bucket" {
    source = "/components/example.com/terramate-aws-s3-bucket/v1"
    inputs = {
      name        = bundle.input.name.value
      acl         = bundle.input.visibility.value
      bundle_uuid = bundle.uuid
      tags = {
        "example.com/bundle-uuid" = bundle.uuid
      }
    }
  }
}

