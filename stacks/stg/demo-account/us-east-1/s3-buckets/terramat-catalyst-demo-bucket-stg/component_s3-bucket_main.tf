// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "s3_bucket" {
  acl                      = "public-read-write"
  block_public_acls        = false
  block_public_policy      = false
  bucket                   = "terramat-catalyst-demo-bucket-stg"
  control_object_ownership = true
  ignore_public_acls       = false
  object_ownership         = "ObjectWriter"
  restrict_public_buckets  = false
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  source = "terraform-aws-modules/s3-bucket/aws"
  tags = {
    "example.com/tf-aws-s3/v1/bundle-uuid" = "0a39e30a-31e5-40da-90e8-e683489758d5"
    "example.com/tf-aws-s3/v1/environment" = "stg"
  }
  version = "5.9.1"
  versioning = {
    enabled = true
  }
}
