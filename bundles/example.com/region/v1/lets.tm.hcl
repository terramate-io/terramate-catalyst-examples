define bundle lets {
  account_alias = bundle.input.account.value.alias
  region        = bundle.input.region.value
  alias         = tm_slug(tm_join("-", [let.account_alias, let.region]))
}
