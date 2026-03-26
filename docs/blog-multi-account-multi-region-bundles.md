# Building Multi-Account, Multi-Region Infrastructure with Terramate Bundles

At KubeCon 2026 in Amsterdam, visitors at our booth kept asking the same question: "How do you handle multi-account, multi-region setups with Terramate Bundles?" It's a fair question — our example repository showed a single account and a single region, and the real world is rarely that simple.

So while we were running the booth, we fired up Claude Code and started building the solution live. What followed was a single interactive session that took the repository from a flat, single-account structure to full multi-account, multi-region support — all while chatting with attendees between prompts.

Here's how that session went.

## The Prompt

We kicked things off with a single natural-language prompt to Claude Code:

> This repository has some terraform and terramate configuration. We would like to add new hierarchy elements for bundle instances and resulting stacks. Those elements shall be a list of accounts and regions. We would like to create new bundle definitions to make configuring accounts and regions possible in an easy way. One bundle shall be to set up a new account giving it an account_alias and an account_id. In addition the account shall get a single environment. For regions we want to use a second class of bundles to add new regions to an account. So we want to select the account to attach the regions to and have a single input `region` to name the region. The existing bundles shall then also make it easy to select a mandatory region. The resulting path for bundle instances shall be extended to `{env}/{account_alias}/{region}/{current-path}`. If a bundle already depends on a bundle that selected a region, we shall not ask for region again but reuse the region by querying the referenced bundle's metadata using `tm_bundle` or `tm_bundles` functions.

That was it. No file paths, no code snippets, no step-by-step instructions. Just the intent.

## The Conversation

What happened next was not a single generation step. Claude Code entered **plan mode**, explored the entire codebase, fetched the Terramate documentation from terramate.io/docs, and then started asking clarifying questions before writing a single line of code.

### Decision 1: Organizational or infrastructure?

> "Are the account and region Bundles purely organizational, or should they also generate Terraform stacks?"

**Our answer: Organizational only.** No Terraform resources. They just provide hierarchy and metadata.

### Decision 2: Environment handling

> "Should the account pick an existing Terramate environment, or is the environment a free-text label?"

**Our answer: Pick existing.** The account selects one of the environments defined in `terramate.tm.hcl` (dev, stg, prd, shr).

### Decision 3: Region inheritance for services

> "For existing Bundles: should they gain a new input to select a region, or depend on a Region Bundle?"

**Our answer: The ECS service inherits from its cluster.** Since a service always depends on a cluster, and the cluster already selected a region, the service should reuse it.

### Decision 4: Path structure

> "Does `{env}/{account_alias}/{region}/{current-path}` mean inserting account and region between the environment and the rest of the path?"

**Our answer: Yes.** So `stacks/dev/fargate-clusters/demo-ecs-cluster/vpc` becomes `stacks/dev/demo-account/us-east-1/fargate-clusters/demo-ecs-cluster/vpc`.

### Decision 5: Region selection UX

> "Should infrastructure Bundles have one input or two for account/region?"

**Our answer: One combined selection.** The user sees `{account_alias} - {region}` as a single dropdown option. The value stores both pieces.

### Decision 6: Keep environment selection

> "Should existing Bundles derive their environment from the account, or keep their own environment selector?"

**Our answer: Keep it.** You need to select the environment first to see the list of accounts and regions available for that environment.

### Decision 7: Examples

> "Should we create example instances alongside the Bundle definitions?"

**Our answer: Both.** Definitions plus working examples so the result is immediately verifiable.

### Decision 8: Environment in config paths

After the initial implementation, we noticed the account config files didn't include the environment in their path. We flagged it and Claude Code fixed the scaffolding paths to include `${bundle.environment.id}`.

## What Claude Code Used

Behind the scenes, the session used several capabilities:

- **Plan mode** — Claude Code explored the codebase and designed the approach before making any changes, presenting a structured plan for approval
- **Parallel exploration agents** — Three agents ran simultaneously: one mapping the Bundle definitions, one analyzing the Terraform configs, and one fetching the Terramate documentation from terramate.io/docs
- **Codebase search** — Glob and grep tools to find all `.tm.hcl`, `.tm.yml`, and `.tf` files and understand the existing patterns
- **Incremental verification** — After each round of changes, `terramate generate` was run to catch errors early. This is how we discovered the `tm_bundle` path limitation and adapted the approach in real time

The entire flow was conversational: prompt, clarify, plan, implement, verify, adjust.

## The Starting Point

Our repository already had three working Bundles:

- An **ECS Fargate Cluster** Bundle that provisions a VPC, ALB, and ECS cluster
- An **ECS Fargate Service** Bundle that attaches services to existing clusters
- An **S3 Bucket** Bundle for storage

Everything lived under a flat path structure:

```
stacks/dev/fargate-clusters/demo-ecs-cluster/vpc
stacks/dev/fargate-clusters/demo-ecs-cluster/alb
stacks/dev/fargate-clusters/demo-ecs-cluster/cluster
stacks/dev/s3-buckets/my-bucket-dev
```

This works fine when you have one AWS account and one region. But the real world has many accounts and regions, and we wanted the directory tree to reflect that.

## The Goal

We wanted the stack paths to look like this:

```
stacks/dev/demo-account/us-east-1/fargate-clusters/demo-ecs-cluster/vpc
```

The account and region segments should come from dedicated Bundles that make it easy to onboard new accounts and regions without touching any infrastructure Bundle definitions.

## Designing the Solution

The first question was whether the Account and Region Bundles should create any Terraform resources themselves. We decided they should be **purely organizational** — no stacks, no Terraform code. They exist solely to provide identity and hierarchy for the infrastructure Bundles that reference them.

The second question was how infrastructure Bundles should pick a region. We settled on a single dropdown that shows `{account} - {region}` combinations. When you scaffold a new ECS cluster, you pick your environment, then pick from the available account-region pairs. That's it.

The third question was about the ECS Service Bundle. It already depends on a cluster, and the cluster already knows its region. So the service should inherit the region from its cluster rather than asking the user to select it again.

## Building the Bundles

### Account Bundle

Three files, no stacks. Just inputs and exports:

```hcl
# inputs.tm.hcl
define bundle {
  input "account_alias" {
    type   = string
    prompt = "Account Alias"
  }

  input "account_id" {
    type   = string
    prompt = "Account ID"
  }
}
```

Creating a new account is as simple as running `terramate scaffold`, picking an environment, typing an alias and an ID. The scaffolded YAML looks like this:

```yaml
apiVersion: terramate.io/cli/v1
kind: BundleInstance
metadata:
  name: demo-account
spec:
  source: /bundles/example.com/account/v1
  inputs:
    account_alias: demo-account
    account_id: "123456789012"
environments:
  dev: {}
```

### Region Bundle

Same pattern. Select an account, type a region name:

```yaml
apiVersion: terramate.io/cli/v1
kind: BundleInstance
metadata:
  name: demo-account-us-east-1
spec:
  source: /bundles/example.com/region/v1
  inputs:
    account: demo-account
    region: us-east-1
environments:
  dev: {}
```

The Region Bundle's scaffolding requires at least one account to exist. If you try to add a region before creating an account, you get a clear error message.

### Updating the Infrastructure Bundles

Each infrastructure Bundle gained a single new input: `region`. The options list is built dynamically from all existing Region Bundle instances:

```hcl
input "region" {
  type = string
  options = [
    for r in tm_bundles("example.com/region/v1") :
    {
      name  = "${r.export.account_alias.value} - ${r.input.region.value}"
      value = "${r.export.account_alias_slug.value}/${r.export.region_slug.value}"
    }
  ]
  prompt = "Account / Region"
}
```

The stack path definitions then use `tm_split` to extract the account and region segments:

```hcl
path = "/stacks/${bundle.environment.id}/${tm_split("/", bundle.input.region.value)[0]}/${tm_split("/", bundle.input.region.value)[1]}/fargate-clusters/${tm_slug(bundle.input.name.value)}/vpc"
```

That's the entire change to make a Bundle account- and region-aware.

## The Result

After adding the account and region inputs to the existing demo cluster config and running `terramate generate`, the stacks moved to their new paths:

```
$ terramate list
stacks/dev/demo-account/us-east-1/fargate-clusters/demo-ecs-cluster/alb
stacks/dev/demo-account/us-east-1/fargate-clusters/demo-ecs-cluster/cluster
stacks/dev/demo-account/us-east-1/fargate-clusters/demo-ecs-cluster/vpc
stacks/dev/demo-account/us-east-1/fargate-clusters/demo-ecs-cluster/workloads/nginx-demo
```

Adding a second account or region is now just a matter of scaffolding new Account and Region Bundle instances. The infrastructure Bundles automatically pick them up in their dropdown options.

## What We'd Improve

During implementation we found that `tm_bundle` and `tm_bundles` functions are not available in `metadata { path }` expressions — only inside `component { inputs }`. This is why we had to store the region value as `account/region` and split it apart with `tm_split`, rather than looking up the Region Bundle directly in the path.

A `lets` block in `define bundle stack` — not yet available but on the roadmap — would make this much cleaner. Instead of repeating `tm_split` calls, you could resolve values once and reference them everywhere:

```hcl
define bundle stack "vpc" {
  lets {
    account_alias = tm_bundle("example.com/region/v1", bundle.input.region.value, bundle.environment.id).export.account_alias.value
    region        = tm_bundle("example.com/region/v1", bundle.input.region.value, bundle.environment.id).export.region.value
  }

  metadata {
    path = "/stacks/${bundle.environment.id}/${lets.account_alias}/${lets.region}/fargate-clusters/..."
  }
}
```

This would also enable true region inheritance for the ECS Service Bundle, where the path could derive account and region from the cluster without needing its own region input at all.

## What Nearly Went Wrong

One thing went wrong during the session that's worth sharing. When restructuring the stack paths, Claude Code deleted the old `stacks/dev/fargate-clusters/` directory and let `terramate generate` recreate the stacks at the new paths. The problem: each stack has a `stack.tm.hcl` file containing a UUID that serves as the stack's stable identity — it's what ties the stack to its Terraform state backend. Deleting and regenerating created new UUIDs, silently breaking the link to any existing state.

The correct approach was to **move** the stack directories to their new locations, preserving the `stack.tm.hcl` files and their UUIDs, then run `terramate generate` to update only the Terraform code around them.

We caught it before merging and restored the original IDs, but it's a good reminder: when working with AI on infrastructure refactoring, your prompt should mention not just what the end state should look like, but **what must survive the transition**. Adding a single sentence to the initial prompt would have prevented the issue entirely:

> The existing stacks are already deployed and their stack IDs must remain stable. When changing paths, move existing stacks rather than recreating them.

The AI sees current state and desired state, but doesn't automatically know which parts of the current state are load-bearing.

## Takeaway

The entire change — two new organizational Bundles, three modified infrastructure Bundles, example instances, and documentation — was built and verified in a single session. Terramate's Bundle composition model made it straightforward to layer account and region concepts on top of existing infrastructure without rewriting anything. The Bundles that were already working kept working; they just gained a new input and a richer path structure.
