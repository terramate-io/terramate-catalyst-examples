define bundle {
  input "region" {
    type        = bundle("example.com/region/v1")
    immutable   = true
    description = "The region to deploy this S3 bucket into"

    prompt {
      text = "Account / Region"
    }
  }

  input "name" {
    type        = string
    description = "A globally unique name of the S3 bucket; it will be suffxed with the current `-{environment}`"

    prompt {
      text = "Name (without environment suffix)"
    }
  }

  input "visibility" {
    type        = string
    description = "Whether the bucket should be private or public"
    default     = "private"

    prompt {
      text = "Bucket Visibility"
      options = [
        { name = "Private", value = "private" },
        { name = "Public Read", value = "public-read" },
        { name = "Public Read/Write", value = "public-read-write" },
      ]
    }
  }

  input "terraform_modules" {
    type        = map(object)
    description = <<-EOF
      A map to control sources and versions of underlying Terraform Modules used in generated code by underlying components.

      The key of the map is the terraform registry ID of the module.

      Available keys:
        - terraform-aws-modules/s3-bucket/aws
    EOF

    default = {
      "terraform-aws-modules/s3-bucket/aws" = {
        source = "terraform-aws-modules/s3-bucket/aws"

        # Terramate Note (TF Module Versioning Example Explanation):
        #
        # We use 5.10.0 in the bundle isntead of "5.9.0" as defined in the component or the "~> 5.0" fall back
        # This enables us to control terraform module versions here, even for remote components.
        # In this repsoitory the component is local and could be updated in place.
        version = "5.9.1"
      }
    }

    # Terramate Note: future version will allow to specify object attribute details in complex objects.

    attribute "source" {
      type        = string
      description = "The source of the specific module to use"
    }

    attribute "version" {
      type        = string
      description = <<-EOF
        The version (contraint) to use for the terraform module. Omit to fall back to this modules default.
      EOF
    }
  }
}
