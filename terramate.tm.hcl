terramate {
  config {
    experiments = ["tmgen"]

    cloud {
      organization = "terramate"
      location     = "eu"
    }
  }
}

import {
  source = "imports/mixins/*.tm.hcl"
}

environment {
  id          = "dev" # [A-Za-z0-9]+
  name        = "Development"
  description = "Development Environment"
  # promote_from = null # default, can not be promoted to
}

environment {
  id           = "stg"
  name         = "Staging"
  description  = "Pre-Prodution Environment: Staging"
  promote_from = "dev"
}

environment {
  id           = "prd"
  name         = "Production"
  description  = "Production Environment"
  promote_from = "stg"
}

environment {
  id          = "shr"
  name        = "Shared"
  description = "A Shared Environment for global resources used by multiple environments."
  # promote_from = null  # default, can not be promoted to=
}
