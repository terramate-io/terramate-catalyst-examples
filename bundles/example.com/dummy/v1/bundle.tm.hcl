define bundle metadata {
  class   = "example.com/dummy/v1"
  version = "1.0.0"

  name        = "Dummy Bundle"
  description = "A placeholder bundle for testing. Does not create any stacks or resources."
}

define bundle {
  alias = tm_slug(bundle.input.name.value)

  scaffolding {
    path = "/configs/dummy/${tm_slug(bundle.input.name.value)}.tm.yml"
    name = tm_slug(bundle.input.name.value)
  }
}
