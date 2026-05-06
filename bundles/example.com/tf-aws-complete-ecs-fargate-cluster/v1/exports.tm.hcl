define bundle {
  export "alias" {
    value = tm_slug(bundle.input.name.value)
  }

  export "name_slug" {
    value = tm_slug(bundle.input.name.value)
  }

  export "alb_name" {
    value = tm_slug(bundle.input.name.value)
  }

  export "account_alias_slug" {
    value = bundle.input.region.value.export.account_alias_slug.value
  }

  export "region_slug" {
    value = bundle.input.region.value.export.region_slug.value
  }
}
