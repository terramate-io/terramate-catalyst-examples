globals "aws" {
  region = "us-east-1"
}

globals "terraform" {
  version = "1.14.1"
}

globals "terraform" "backend" {
  type = "local"
}

globals "terraform" "backend" "s3" {
  bucket = "example-terraform-state-backend"
  region = global.aws.region
}

globals "terraform" "providers" "aws" {
  enabled = true

  source  = "hashicorp/aws"
  version = "6.25.0"
  config = {
    region = global.aws.region
  }
}

globals "terraform" "providers" "null" {
  enabled = true

  source  = "hashicorp/null"
  version = "3.2.0"
}

globals {
  environments = {
    dev = "Development"
    stg = "Staging"
    prd = "Production"
  }
}
