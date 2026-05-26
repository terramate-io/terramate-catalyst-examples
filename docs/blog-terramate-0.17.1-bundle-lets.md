# Terramate 0.17.1: Iterating on the Examples Again — Bundle Authors Get Their Turn

The [previous post](./blog-terramate-0.17-bundle-types.md) was about changes we made to the [terramate-catalyst-examples](https://github.com/terramate-io/terramate-catalyst-examples) repo that improved life for the people *using* Bundles — better typed inputs, fewer redundant questions, multi-environment configs. Good iteration. But the people *writing* the Bundles were still repeating themselves.

This post is about the next round of changes we applied to the same repo. The headline addition is the new `define bundle lets` block, which we used to clean up duplication that had been hiding in plain sight across the example Bundles. As before, the goal isn't to recap a release — it's to show what we improved in the examples and why.

If you haven't read the [original KubeCon post](./blog-multi-account-multi-region-bundles.md) or the [follow-up on typed Bundle inputs](./blog-terramate-0.17-bundle-types.md), they set the stage for what the examples looked like before this round.

## What We Changed

Each example Bundle now has a `lets.tm.hcl` file that declares computed values once:

```hcl
define bundle lets {
  name_slug   = tm_slug(bundle.input.name.value)
  path_prefix = "/stacks/${bundle.environment.id}/${let.name_slug}"
  # Note: inside the lets block itself, sibling values are referenced as
  # `let.name_slug`. From anywhere else in the Bundle, use `bundle.let.name_slug`.
}
```

The rest of the Bundle references these via `bundle.let.<name>`. Stack files that used to carry repeated, half-a-line-wide expressions now read like:

```hcl
metadata {
  path = "${bundle.let.path_prefix}/vpc"
}
```

That's the whole pattern. The change is small in the abstract and surprisingly impactful in practice.

## Why It's Worth the Iteration

Two benefits hold across the example catalog:

**Single source of truth.** Change how a value is built — a name, a path, a tag prefix — change it in one place. The example ECS Cluster Bundle had `tm_slug(bundle.input.name.value)` appear in five different places (alias, scaffolding path, scaffolding name, plus stack tags in three stack files). One let, five references collapsed.

**Readable definitions.** Stack files stop being walls of nested attribute access. A let at the top of the Bundle does the same work HCL `locals` do in Terraform: hoist the common subexpressions, give them names, let the rest of the file read like prose.

## Cleaner Cross-Bundle Composition

The example ECS Service Bundle used to reach into its referenced cluster via `bundle.input.cluster.value.export.X.value` chains four times in component inputs. We pulled that into a let:

```hcl
define bundle lets {
  cluster = bundle.input.cluster.value
}
```

And the rest of the file reads like normal HCL: `bundle.let.cluster.export.alb_name.value`, `bundle.let.cluster.alias`, and so on. One reference cached, dereferenced freely.

A note on style we adopted across the examples: when a Bundle needs to refer to another Bundle, prefer a **typed `bundle(...)` input** over calling `tm_bundle()` in a let. Both work, but typed inputs make the dependency explicit, which lets Terramate reason about ordering when promoting changes between environments. `tm_bundle()` and `tm_bundles()` remain useful when typed inputs don't fit — for example, when a Bundle wants to discover any instances of a class without declaring one specifically — but typed inputs are the default in the examples now.

## The Bundle Author Story

If you stack everything we've applied to the examples across the three posts:

1. **Typed `bundle(...)` inputs** make Bundle-to-Bundle references first-class values, not strings to parse
2. **`define bundle lets`** lets Bundle authors compute derived values once and name them
3. **The pattern of caching a typed input in a let** ties them together — declare the dependency, cache it, use it freely

Each is useful alone. Together they replace a category of workaround the original KubeCon post leaned on — encoding compound values as split-able strings, smuggling state through "passthrough" exports, asking the user the same question in different shapes.

## What Developers Consuming Bundles Won't Notice

The thing about Bundle author improvements is that the consumer experience doesn't change. If you're scaffolding infrastructure rather than writing Bundles, the examples look identical from the outside — the dropdowns work the same, the YAML files look the same, the generated stacks live in the same paths.

That's by design. The job of Bundle authors is to make sure consumers don't have to think about any of this. Each round of iteration that makes the author's job easier quietly raises the ceiling on what consumers can do without ever knowing why.

## Takeaway

Post one was about getting multi-account, multi-region infrastructure to work at all. Post two was about the iteration that closed the gap for the people who *use* the example Bundles. Post three is about the iteration that closes it for the people who *write* them.

If you maintain a Bundle catalog of any size, this is the round of changes where authoring starts feeling like real code — with locals, with composition, with one obvious place to change each thing.
