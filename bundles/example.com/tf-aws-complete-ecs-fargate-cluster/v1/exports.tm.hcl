define bundle {
  export "alias" {
    value = bundle.let.name_slug
  }

  export "name_slug" {
    value = bundle.let.name_slug
  }

  export "alb_name" {
    value = bundle.let.name_slug
  }

  export "account_alias_slug" {
    value = bundle.let.account_slug
  }

  export "region_slug" {
    value = bundle.let.region_slug
  }
}
