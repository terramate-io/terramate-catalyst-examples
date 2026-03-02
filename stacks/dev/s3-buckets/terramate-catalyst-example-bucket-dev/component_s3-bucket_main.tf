// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "s3_bucket" {
  acl                      = "private"
  block_public_acls        = true
  block_public_policy      = true
  bucket                   = "terramate-catalyst-example-bucket-dev"
  control_object_ownership = true
  ignore_public_acls       = true
  object_ownership         = "ObjectWriter"
  restrict_public_buckets  = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  source = "terraform-aws-modules/s3-bucket/aws"
  tags = {
    "example.com/tf-aws-s3/v1/bundle-uuid" = "efc2ba80-bdff-4a9e-888c-8aa8aa0edc65"
    "example.com/tf-aws-s3/v1/environment" = "dev"
  }
  version = "5.9.1"
  versioning = {
    enabled = true
  }
}
