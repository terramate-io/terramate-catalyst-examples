define bundle metadata {
  class   = "example.com/region/v1"
  version = "1.0.0"

  name        = "AWS Region"
  description = <<-EOF
    Organizational bundle that represents a region within an account.
    This bundle does not create any Terraform stacks. It serves as a
    reference for infrastructure bundles to derive region and account identity.
  EOF
}

define bundle {
  alias = bundle.let.alias

  environments {
    required = true
  }

  scaffolding {
    path = "/configs/accounts/${tm_slug(bundle.let.account_alias)}/region_${tm_slug(bundle.let.region)}.tm.yml"
    name = bundle.let.alias
  }
}
