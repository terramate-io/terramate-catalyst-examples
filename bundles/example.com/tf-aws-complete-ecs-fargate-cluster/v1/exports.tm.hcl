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
}
