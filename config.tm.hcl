globals "terraform" {
  version = "1.14.1"
}

globals "aws" {
  # Derive the AWS region from the stack path (/stacks/{env}/{account}/{region}/...).
  # All stack-generating bundles in this repo follow this hierarchy.
  # Stacks not in this hierarchy fall back to "us-east-1".
  # Override with a fixed string to force a specific region for all stacks.
  region = tm_try(tm_split("/", terramate.stack.path.absolute)[4], "us-east-1")
}

## configure available environments

globals {
  environments = {
    dev = "Development"
    stg = "Staging"
    prd = "Production"
  }
}

## local backend

globals "terraform" "backend" {
  type = "local"
}

## S3 backend

# globals "terraform" "backend" {
#   type = "s3"

#   s3 = {
#     bucket = "example-terraform-state-backend"
#     region = "us-east-1"
#   }
# }
