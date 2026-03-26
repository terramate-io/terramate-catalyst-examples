define component {
  input "name" {
    type        = string
    description = "The name of the S3 bucket"

    prompt {
      text = "S3 Bucket Name"
    }
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

  input "terraform_modules" {
    type        = map(any)
    description = <<-EOF
      A map to control sources and versions of underlying Terraform Modules used in generated code by this component.

      The key of the map is the terraform registry ID of the module.

      Available keys:
        - terraform-aws-modules/s3-bucket/aws

      The versions defined here can be controlled where the component is intantiated, e.g. in Bundle Stacks.
    EOF

    default = {
      "terraform-aws-modules/s3-bucket/aws" = {
        source = "terraform-aws-modules/s3-bucket/aws"

        # Terramate Note (TF Module Versioning Example Explanation):
        #
        # by default this component should use version 5.9.0 of the module instead of the "~> 5.0" fallback.
        # this can be overwritten by the component instance configuration e.g. in a bundle stack
        version = "5.9.0"
      }
    }

    # Terramate Note: future version will allow to specify object attribute details in complex objects.

    # attribute "source" {
    #   type        = string
    #   description = "The source of the specific module to use"
    # }

    # attribute "version" {
    #   type        = string
    #   description = <<-EOF
    #     The version (contraint) to use for the terraform module. Omit to fall back to this modules default.
    #   EOF
    # }
  }
}
