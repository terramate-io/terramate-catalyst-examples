define bundle {
  input "account_alias" {
    type        = string
    description = "A human-friendly alias for the account (e.g., 'my-prod-account')"

    prompt {
      text = "Account Alias"
    }
  }

  input "account_id" {
    type        = string
    description = "The account identifier (e.g., AWS 12-digit account ID or GCP project ID)"

    prompt {
      text = "Account ID"
    }
  }
}
