define bundle metadata {
  class   = "example.com/dummy/v1"
  version = "1.0.0"

  name        = "Dummy Bundle"
  description = "A placeholder bundle for testing. Does not create any stacks or resources."
}

define bundle {
  alias = bundle.let.name_slug

  scaffolding {
    path = "/configs/dummy/${bundle.let.name_slug}.tm.yml"
    name = bundle.let.name_slug
  }
}
