define bundle {
  input "account" {
    type        = bundle("example.com/account/v1")
    immutable   = true
    description = "The account to associate this region with"

    prompt {
      text = "Account"
    }
  }

  input "region" {
    type        = string
    immutable   = true
    description = "The region identifier (e.g., us-east-1, eu-west-1)"

    prompt {
      text = "Region"
    }
  }
}
