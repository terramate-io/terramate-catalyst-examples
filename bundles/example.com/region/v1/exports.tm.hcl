define bundle {
  export "region" {
    value = bundle.let.region
  }

  export "account_alias" {
    value = bundle.let.account_alias
  }

  export "account_alias_slug" {
    value = tm_slug(bundle.let.account_alias)
  }

  export "region_slug" {
    value = tm_slug(bundle.let.region)
  }
}
