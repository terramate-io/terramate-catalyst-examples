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
  alias = tm_slug(tm_join("-", [bundle.input.account.value.alias, bundle.input.region.value]))

  environments {
    required = true
  }

  scaffolding {
    path = "/configs/accounts/${tm_slug(bundle.input.account.value.alias)}/region_${tm_slug(bundle.input.region.value)}.tm.yml"
    name = tm_slug(tm_join("-", [bundle.input.account.value.alias, bundle.input.region.value]))
  }
}
