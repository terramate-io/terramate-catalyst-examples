define bundle lets {
  name_slug    = tm_slug(bundle.input.name.value)
  account_slug = bundle.input.region.value.export.account_alias_slug.value
  region_slug  = bundle.input.region.value.export.region_slug.value
  cluster_name = tm_join("-", [let.name_slug, bundle.environment.id])
  path_prefix  = "/stacks/${bundle.environment.id}/${let.account_slug}/${let.region_slug}/fargate-clusters/${let.name_slug}"
}
