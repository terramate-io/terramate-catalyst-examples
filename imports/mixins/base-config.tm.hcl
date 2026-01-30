# DO NOT EDIT - use /config.tm.hcl instead
#
# this is the base config that can be overwritten on the /config.tm.hcl files or anywhere in the hierarchy.
# it is required to provide an initial state wven when no specific configuration overwrites exist.
# it should only be edited by maintainer of this repository but not used to actually change configuration
# instead copy relevant parts not yet existing in /config.tm.hcl and change them there.

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
  source  = "hashicorp/aws"
  version = "6.25.0"
  config = {
    region = global.aws.region
  }
}

globals "terraform" "providers" "null" {
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
