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
