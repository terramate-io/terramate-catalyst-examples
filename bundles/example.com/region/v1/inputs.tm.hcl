define bundle {
  input "account" {
    type        = string
    description = "The account alias to associate this region with"

    prompt {
      text = "AWS Account"
      options = [
        for acct in tm_bundles("example.com/account/v1") :
        { name = acct.input.account_alias.value, value = acct.export.account_alias.value }
      ]
    }
  }

  input "region" {
    type        = string
    description = "The region identifier (e.g., us-east-1, eu-west-1)"

    prompt {
      text = "Region"
    }
  }
}
