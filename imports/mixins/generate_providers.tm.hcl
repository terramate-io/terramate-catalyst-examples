# This file generates a `terraform.tf` file in each stack

# This is a one time setup and easy to configure later approach
# this file can be imported into the root of all stacks and takes care of generating
# provider and terraform version of required providers only.

# It can be extended for more complex providers easily - which again is a one time effort per provider.
# But most simple providers requiring simple configurations work out of the box.

# What is generated?

# This logic generates Terraform provider configuration for all stacks that have
# tags in the following format set:
# - `terraform/provider/{provider}`

# example tags: 'terraform/provider/aws', 'terraform/provider/null'

#
# TERRAMATE - B U N D L E S
#
# Those tags can be set in Bundle Stacks Metadata and do not need to be set
# on the stack itselfs manually
#
# this enables bundles to dynamically trigger generation of configuration for specific providers.
#

# Provider details like version can be configured using globals

# A global `terraform.providers[{provider}]` can be created
# having the follwoing structure:
#
# `source` - The provider source
# `enabled` - set to true to disable a provider for all lower stack in the hiearchy
# `version` - the version constraint to use - is recommneded to pin to a specific version
# `config` - an optional object to configure the provider block,
#            no provider block will be added when omitted

# other globals can be used to make configuration more flexible too.

# HOW configuration works

# - configure the globals on top of the hierarchy. it will inherit to each stack
# - overwrite specifics within the hierarchy: set a new version for a subtree for specific providers
# - make configuration conditional on other globals: use 7.0 in dev, else use 6.0
#
#    version = global.environment == "dev" ? "7.0" : "6.0"

# complex configuration
# - e.g. the kubernetes provider requires more complex configuration including data sources:
#   we recommend to generate a second file just for kubernetes
#   depending if that provider is requested or not. Add the data sources and provider block there.
#   and do NOT add the `config` section in the global
# - providers with blocks: the configuration can by dynamically extended to support any blocks within provider blocks
#   this example is intentionally kept small.

# To disable this behavior either:
# - set the global `terraform.disabled` to `true`.
# - set a stack tag named `terraform/disabled`
# - or just remove this file
# - to rename the generated file or change/extend the behavior, just edit it below ;)

generate_hcl "terraform.tf" {
  # check if we want to generate the file.
  condition = tm_alltrue([
    tm_try(global.terraform.disabled != true, true),
    !tm_contains(terramate.stack.tags, "terraform/disabled"),
  ])

  lets {
    # check stack tags to enable providers per stack
    # stack tags can be inherited by bundle stacks and do NOT need to be configured manually
    stack_providers = [
      for tag in terramate.stack.tags :
      tm_trimprefix(tag, "terraform/provider/")
      if tm_startswith(tag, "terraform/provider/")
    ]

    # required providers configuration to define provider sources and versions
    #  - all providers configured in globals that are also in stack tags, will be set up.
    required_providers = { for k, v in tm_try(global.terraform.providers, {}) :
      k => {
        source  = v.source
        version = v.version
        } if tm_alltrue([
          tm_try(v.enabled, tm_contains(let.stack_providers, k)),
          tm_length(tm_split(".", k)) == 1,
      ])
    }


    # provider configurations to define the desired settings for each provider
    providers = { for k, v in tm_try(global.terraform.providers, {}) :
      k => v.config if tm_alltrue([
        tm_length(tm_split(".", k)) == 1,
        tm_try(v.enabled, tm_contains(let.stack_providers, k)),
        tm_can(v.config)
      ])
    }

    providers_aliases = { for k, v in tm_try(global.terraform.providers, {}) :
      k => v.config if tm_alltrue([
        tm_length(tm_split(".", k)) == 2,
        tm_try(v.enabled, true),
        tm_can(v.config)
      ])
    }
  }

  content {
    # terraform version constraints
    terraform {
      required_version = tm_try(global.terraform.version, "~> 1.14")
    }

    # Provider version constraints
    tm_dynamic terraform {
      condition = tm_length(let.required_providers) > 0
      content {

        tm_dynamic "required_providers" {
          attributes = let.required_providers
        }
      }
    }

    tm_dynamic "provider" {
      for_each   = let.providers
      labels     = [provider.key]
      attributes = provider.value
    }


    # Provider aliases

    tm_dynamic "provider" {
      for_each   = let.providers_aliases
      labels     = [tm_split(".", provider.key)[0]]
      attributes = provider.value

      content {
        alias = tm_split(".", provider.key)[1]
      }
    }
  }
}
