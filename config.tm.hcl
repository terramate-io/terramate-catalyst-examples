globals "terraform" {
  version = "1.14.1"
}

globals "aws" {
  region = "us-east-1"
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
#
#   s3 = {
#     bucket = "example-terraform-state-backend"
#     region = "us-east-1"
#   }
# }
