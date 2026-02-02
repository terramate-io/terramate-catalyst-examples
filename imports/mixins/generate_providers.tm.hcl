# This file generates a `terraform.tf` file in each stack

# This is a one-time setup that's easy to configure later
# This file can be imported into the root of all stacks and takes care of generating
# the provider and Terraform versions of required providers only.

# It can be easily extended for more complex providers - which again is a one-time effort per provider.
# Most providers requiring simple configuration work out of the box.

# What is generated?
#
# This mixin generates a `terraform.tf` file (including the `terraform` block with
# `required_version`) for all stacks, unless explicitly disabled (see below).
#
# In addition, it generates Terraform provider configuration (`required_providers`
# and `provider` blocks) for all stacks that have tags in the following format set:
# - `terraform/provider/{provider}`
#   example tags: 'terraform/provider/aws', 'terraform/provider/null'
#
# TERRAMATE - Bundles
#
# Those tags can be set in Bundle Stacks Metadata and do not need to be set
# on the stack itself manually
#
# This enables bundles to dynamically trigger the generation of configuration for specific providers.
#

# Provider details, such as versions, can be configured using globals

# A global `terraform.providers[{provider}]` can be created
# with the following structure:
#
# `source` - the provider source
# `enabled` - set to true to enable a provider for all lower stacks in the hierarchy; set to false to disable it regardless of stack tags
# `version` - the version constraint to use - it is recommended to pin to a specific version
# `config` - an optional object to configure the provider block,
#            no provider block will be added when omitted

# Other globals can be used to make configuration more flexible as well.

# How configuration works

# - Configure the globals at the top of the hierarchy. They will be inherited by each stack
# - Override specifics within the hierarchy: set a new version for a subtree for specific providers
# - Make configuration conditional on other globals: use 7.0 in dev, otherwise use 6.0
#
#    version = global.environment == "dev" ? "7.0" : "6.0"

# Complex configuration
# - For example, the Kubernetes provider requires more complex configuration, including data sources:
#   We recommend generating a second file just for Kubernetes
#   depending on whether that provider is requested. Add the data sources and provider block there.
#   and do NOT add the `config` section in the global.
# - Providers with blocks: the configuration can be dynamically extended to support any blocks within provider blocks
#   This example is intentionally kept small.

# To disable or modify this behavior:
# - set the global `terraform.disabled` to `true`.
# - set a stack tag named `terraform/disabled`.
# - or just remove this file.
# - To rename the generated file or change/extend the behavior, just edit it below ;)

generate_hcl "terraform.tf" {
  # Check whether we want to generate the file.
  condition = tm_alltrue([
    tm_try(global.terraform.disabled != true, true),
    !tm_contains(terramate.stack.tags, "terraform/disabled"),
  ])

  lets {
    # Check stack tags to enable providers per stack
    # Stack tags can be inherited by bundle stacks and do NOT need to be configured manually
    stack_providers = [
      for tag in terramate.stack.tags :
      tm_trimprefix(tag, "terraform/provider/")
      if tm_startswith(tag, "terraform/provider/")
    ]

    # Required providers configuration defines provider sources and versions
    #  - All providers configured in globals that are also in stack tags will be set up.
    required_providers = { for k, v in tm_try(global.terraform.providers, {}) :
      k => {
        source  = v.source
        version = v.version
        } if tm_alltrue([
          tm_try(v.enabled, tm_contains(let.stack_providers, k)),
          tm_length(tm_split(".", k)) == 1,
      ])
    }


    # Provider configurations define the desired settings for each provider
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
        tm_try(v.enabled, tm_contains(let.stack_providers, k)),
        tm_can(v.config)
      ])
    }
  }

  content {
    # Terraform version constraints
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
