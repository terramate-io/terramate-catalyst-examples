define component metadata {
  class   = "example.io/tf-aws-s3"
  version = "1.0.0"

  name         = "AWS S3 Bucket Component"
  description  = "Component that allows creating a private S3 bucket on AWS with versioning enabled."
  technologies = ["terraform", "opentofu"]
}

define component {
  input "name" {
    type        = string
    prompt      = "S3 Bucket Name"
    description = "The name of the S3 bucket"
  }

  input "tags" {
    type        = map(string)
    description = "Tags to apply to resources"
    default     = {}
  }
}
