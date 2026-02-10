define bundle metadata {
  class   = "example.com/tf-aws-s3/v1"
  version = "1.0.0"

  name        = "AWS S3 Bucket"
  description = <<-EOF
    Creates and manage a private or public AWS S3 Bucket.

    Amazon Simple Storage Service (Amazon S3) is an object storage service offering industry-leading scalability, data availability, security, and performance.
  EOF
}

define bundle {
  alias = tm_slug(bundle.input.name.value)


  # Tis bundle requires environments support
  environments {
    required = true
  }

  scaffolding {
    path = "/configs/s3-buckets/s3_${tm_slug(bundle.input.name.value)}.tm.hcl"
    name = tm_slug(bundle.input.name.value)
  }
}
