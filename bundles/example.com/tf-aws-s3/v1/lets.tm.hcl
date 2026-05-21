define bundle lets {
  name_slug    = tm_slug(bundle.input.name.value)
  bucket_name  = "${bundle.input.name.value}-${bundle.environment.id}"
  bucket_slug  = tm_slug(let.bucket_name)
  account_slug = bundle.input.region.value.export.account_alias_slug.value
  region_slug  = bundle.input.region.value.export.region_slug.value
  path_prefix  = "/stacks/${bundle.environment.id}/${let.account_slug}/${let.region_slug}/s3-buckets/${let.bucket_slug}"
}
