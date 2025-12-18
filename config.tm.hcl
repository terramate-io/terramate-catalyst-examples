globals "terraform" {
  version = "1.14.1"
}

globals "terraform" "providers" "aws" {
  region = "us-east-1"
}

globals "terraform" "backend" {
  bucket = "terramate-rene-terraform-state-backend"
  region = global.terraform.providers.aws.region
}

globals "terraform" "providers" "aws" {
  enabled = true

  source  = "hashicorp/aws"
  version = "~> 6.25.0"
  config = {
    region = global.terraform.providers.aws.region
  }
}

globals "terraform" "providers" "null" {
  enabled = true

  source  = "hashicorp/null"
  version = "~> 3.2.0"
}

globals {
  environments = [
    "dev",
    "stg",
    "prod",
  ]
}
