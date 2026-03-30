define bundle metadata {
  class   = "example.com/account/v1"
  version = "1.0.0"

  name        = "AWS Account"
  description = <<-EOF
    Organizational bundle that represents an AWS account.
    This bundle does not create any Terraform stacks. It serves as a
    reference for region and infrastructure bundles to derive account
    identity (alias, account ID).
  EOF
}

define bundle {
  alias = tm_slug(bundle.input.account_alias.value)

  environments {
    required = true
  }

  scaffolding {
    path = "/configs/accounts/${bundle.environment.id}/${tm_slug(bundle.input.account_alias.value)}.tm.yml"
    name = tm_slug(bundle.input.account_alias.value)
  }
}
