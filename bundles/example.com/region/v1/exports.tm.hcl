define bundle {
  export "region" {
    value = bundle.input.region.value
  }

  export "account_alias" {
    value = bundle.input.account.value.alias
  }

  export "account_alias_slug" {
    value = tm_slug(bundle.input.account.value.alias)
  }

  export "region_slug" {
    value = tm_slug(bundle.input.region.value)
  }
}
