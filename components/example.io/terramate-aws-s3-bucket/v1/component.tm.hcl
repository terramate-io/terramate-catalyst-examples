define component metadata {
  class   = "example.io/tf-aws-s3"
  version = "1.0.0"

  name         = "AWS S3 Bucket Component"
  description  = "Component that allows creating an S3 bucket on AWS with configurable ACL (default: private) and versioning enabled."
  technologies = ["terraform", "opentofu"]
}

define component {
  input "name" {
    type        = string
    prompt      = "S3 Bucket Name"
    description = "The name of the S3 bucket"
  }

  input "acl" {
    type        = string
    description = "Access Control List (ACL) for the bucket. Valid values: 'private', 'public-read', 'public-read-write', 'aws-exec-read', 'authenticated-read', 'bucket-owner-read', 'bucket-owner-full-control', 'log-delivery-write'"
    default     = "private"
  }

  input "tags" {
    type        = map(string)
    description = "Tags to apply to resources"
    default     = {}
  }
}
