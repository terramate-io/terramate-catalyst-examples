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

  # Passes through the "account_alias/region" value for downstream bundles
  export "region_ref" {
    value = bundle.input.region.value
  }
}
