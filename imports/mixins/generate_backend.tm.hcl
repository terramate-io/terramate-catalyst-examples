generate_hcl "backend.tf" {
  condition = tm_alltrue([
    tm_try(global.terraform.backend.type == "s3", false),
    tm_can(global.terraform.backend.s3.region),
    tm_can(global.terraform.backend.s3.bucket),
  ])

  content {
    terraform {
      backend "s3" {
        region       = global.terraform.backend.s3.region
        bucket       = global.terraform.backend.s3.bucket
        key          = tm_try(global.terraform.backend.s3.key, "terraform/stacks/by-id/${terramate.stack.id}/terraform.tfstate")
        encrypt      = true
        use_lockfile = true
      }
    }
  }
}

generate_hcl "backend.tf" {
  condition = tm_alltrue([
    tm_try(global.terraform.backend.type == "local", false),
  ])

  content {
    terraform {
      backend "local" {
      }
    }
  }
}
