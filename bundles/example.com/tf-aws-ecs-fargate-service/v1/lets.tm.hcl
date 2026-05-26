define bundle lets {
  cluster      = bundle.input.cluster.value
  service_slug = tm_slug(bundle.input.service_name.value)
  service_name = tm_join("-", [let.cluster.alias, let.service_slug])
  account_slug = let.cluster.export.account_alias_slug.value
  region_slug  = let.cluster.export.region_slug.value
  path_prefix  = "/stacks/${bundle.environment.id}/${let.account_slug}/${let.region_slug}/fargate-clusters/${let.cluster.alias}/workloads/${let.service_slug}"
}
