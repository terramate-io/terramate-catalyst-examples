// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "s3_bucket" {
  acl                      = "private"
  block_public_acls        = true
  block_public_policy      = true
  bucket                   = "s3-example-bucket"
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
    "example.com/bundle-uuid" = "c3de2260-871a-4cad-9a3b-c00076060258"
  }
  version = "5.9.0"
  versioning = {
    enabled = true
  }
}
