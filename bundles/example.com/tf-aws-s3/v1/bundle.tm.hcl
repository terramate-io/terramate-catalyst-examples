define bundle metadata {
  class   = "example.com/tf-aws-s3/v1"
  version = "1.0.0"

  name         = "Amazon Simple Storage Service Bucket (AWS S3)"
  description  = <<-EOF
    Creates and manage a private or public AWS S3 Bucket.

    Amazon Simple Storage Service (Amazon S3) is an object storage service offering industry-leading scalability, data availability, security, and performance.
  EOF
}

define bundle {
  alias = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])

  scaffolding {
    path = "/stacks/${bundle.input.env.value}/s3/_bundle_s3_${tm_slug(bundle.input.name.value)}.tm.hcl"
    name = tm_slug(bundle.input.name.value)
  }
}
