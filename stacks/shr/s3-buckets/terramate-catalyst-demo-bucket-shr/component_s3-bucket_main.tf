// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "s3_bucket" {
  acl                      = "public-read"
  block_public_acls        = false
  block_public_policy      = false
  bucket                   = "terramate-catalyst-demo-bucket-shr"
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
    "example.com/tf-aws-s3/v1/bundle-uuid" = "7e6c3676-a315-44f9-afe0-7812906ea03a"
    "example.com/tf-aws-s3/v1/environment" = "shr"
  }
  version = "5.9.1"
  versioning = {
    enabled = true
  }
}
