# What Terramate 0.17 Changes for Multi-Account, Multi-Region Setups

> **Update — Terramate 0.17.1:** A follow-up release closes the gap for Bundle authors with `define bundle lets`, eliminating the repetition that remained inside Bundle definitions themselves. See [Terramate 0.17.1: Bundle Authors Get Their Turn](./blog-terramate-0.17.1-bundle-lets.md).

A few months ago we wrote about [building multi-account, multi-region infrastructure with Terramate Bundles](./blog-multi-account-multi-region-bundles.md) — the result of a live coding session at our KubeCon Amsterdam booth. The setup worked, but the post ended on a self-critical note: we had to lean on workarounds, encode compound values as split-able strings, and ask the user the same question twice in different shapes.

Terramate 0.17 fixes most of that. We've rebuilt the same example using the new release and the result is shorter, clearer, and friendlier to whoever ends up scaffolding infrastructure on a Friday afternoon. Here's what changed.

## The Original Pain Points

If you skimmed the first post, here's the short version of what didn't feel right:

- **Cross-bundle references were strings.** When the ECS Cluster Bundle needed to point at a Region Bundle, we stored the value as `"demo-account/us-east-1"` and split it apart whenever we needed the pieces. It worked, but it wasn't self-documenting.
- **The Service Bundle asked for the region twice.** A service belongs to a cluster, and the cluster already has a region. The right behavior was for the service to inherit the region, but the tool couldn't express that — so the user got asked again.
- **Validation was bolted on.** Each Bundle had an `enabled` block that checked whether prerequisite Bundle instances existed before scaffolding. Five lines of error message every time a user might run into a "you need a region first" situation.
- **Per-environment configuration was per-file.** Three environments meant three nearly-identical config files for the same logical account.

None of these were blockers. They were friction.

## What 0.17 Brings

Two changes do most of the heavy lifting.

### Bundle References Are a First-Class Type

Inputs can now be typed as `bundle("...")`. Instead of asking the user for a string and hoping it matches a real instance, the input is wired directly to other Bundle instances. The CLI populates the dropdown for you, and inside the Bundle definition you get the referenced Bundle's inputs, exports, and metadata as a structured object — not a string you have to parse.

In our example, the Service Bundle now references a Cluster Bundle directly:

```hcl
input "cluster" {
  type        = bundle("example.com/tf-aws-complete-ecs-fargate-cluster/v1")
  immutable   = true
  description = "The ECS cluster to attach this service to"
}
```

The Service can then read the cluster's region, account, and alias directly — for example to compose its stack path:

```hcl
path = tm_join("/", [
  "/stacks",
  bundle.environment.id,
  bundle.input.cluster.value.export.account_alias_slug.value,
  bundle.input.cluster.value.export.region_slug.value,
  "fargate-clusters",
  bundle.input.cluster.value.alias,
  "workloads",
  tm_slug(bundle.input.service_name.value),
])
```

No string parsing, no second region prompt — the relationship is just there.

### Multi-Environment Configs Without Multi-Files

A single Bundle instance file can now describe what's the same across environments and what differs, in one place:

```yaml
spec:
  inputs:
    account_alias: demo-account
environments:
  dev:
    inputs:
      account_id: "111111111111"
  prd:
    inputs:
      account_id: "333333333333"
```

The shared inputs live at the top, the per-environment differences live underneath. We deleted six files going from the old structure to the new one — and gained clarity in the process.

## Smaller Quality-of-Life Changes

A handful of smaller improvements add up:

- **`immutable = true` on inputs** that should never change after creation — like the account alias and region. The CLI prevents accidental edits, and reviewers don't have to police it in PRs.
- **A cleaner input prompt syntax** that moves prompt-related attributes into a sub-block.
- **Fewer manual safeguards.** Because `bundle(...)` types only resolve against real instances, the explicit "this Bundle requires another Bundle" error blocks aren't needed. The type system handles it implicitly.

## What Disappeared from Our Code

Putting it all together, here's what fell out:

- The `tm_split` workarounds in stack paths — gone. The path uses the cluster's exported region directly.
- The redundant `region` input on the Service Bundle — gone. The cluster already knows.
- The `region_ref` "passthrough" export we invented to smuggle the region as a string — gone.
- The `enabled` validation blocks on four Bundles — gone.
- Six per-environment account/region files — collapsed into two.

The Bundle definitions are shorter. The example configs are fewer. And the developer experience — the part most people actually see — gets noticeably less repetitive.

## Why This Matters for Developers Consuming Bundles

If you're a developer scaffolding infrastructure rather than authoring Bundles, you won't read most of this. You'll just notice:

- The dropdown for "which cluster?" actually shows the right list, with the right info.
- After picking a cluster, you don't get asked which region — it just happens.
- If you try to set up a region before any account exists, the CLI points you at the right next step instead of erroring on a string mismatch later.
- The YAML files in the repo look smaller and less repetitive when you skim them.

That's the goal. The infrastructure consumption layer should fade into the background. Each release that closes a gap between "what makes sense" and "what the tool can express" makes that more achievable.

## Takeaway

The first post made the case that Terramate Bundles let you compose hierarchies on top of existing infrastructure without rewriting things. The 0.17 release makes the same composition feel native: typed bundle references, environment-aware configs, and immutability enforced where it matters. The example we built at the booth got noticeably better with one upgrade and a handful of well-targeted edits — which is the right kind of release to ship.
