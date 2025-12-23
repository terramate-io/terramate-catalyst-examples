define bundle {
  export "alias" {
    value = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])
  }

  export "name_slug" {
    value = tm_slug(bundle.input.name.value)
  }

  export "env" {
    value = bundle.input.env.value
  }

  export "alb_name" {
    value = tm_join("-", [tm_slug(bundle.input.name.value), bundle.input.env.value])
  }
}
