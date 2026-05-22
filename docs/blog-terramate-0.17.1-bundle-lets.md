# Terramate 0.17.1: Bundle Authors Get Their Turn

Terramate 0.17.1 introduces `define bundle lets` — a way for Bundle authors to compute values once and reuse them across a Bundle's alias, scaffolding, exports, and stacks. Combined with the `bundle(...)` input type from 0.17 and the ability to call `tm_bundle()` and `tm_bundles()` anywhere a Bundle is evaluated, it closes the last of the repetition gaps that Bundle authors had been working around.

If you've followed this series, you'll recognize the throughline. The [original post](./blog-multi-account-multi-region-bundles.md) was a live coding session at our KubeCon Amsterdam booth: we built multi-account, multi-region support into the [terramate-catalyst-examples](https://github.com/terramate-io/terramate-catalyst-examples) repo and ended on a list of workarounds we wished we hadn't needed. The [follow-up post on 0.17](./blog-terramate-0.17-bundle-types.md) covered the release that closed most of those gaps — for the people *using* Bundles. This post covers 0.17.1, which closes them for the people *writing* Bundles.

## What Terramate 0.17.1 Adds

The headline feature is **`define bundle lets`**, a top-level block inside a Bundle definition for declaring computed values:

```hcl
define bundle lets {
  name_slug   = tm_slug(bundle.input.name.value)
  path_prefix = "/stacks/${bundle.environment.id}/${let.name_slug}"
  # Note: inside the lets block itself, sibling values are referenced as
  # `let.name_slug`. From anywhere else in the Bundle, use `bundle.let.name_slug`.
}
```

References from elsewhere in the Bundle use `bundle.let.<name>`. Stack files that used to carry repeated, half-a-line-wide expressions now read like:

```hcl
metadata {
  path = "${bundle.let.path_prefix}/vpc"
}
```

Two smaller-but-meaningful improvements landed alongside it:

- **`tm_bundle()` and `tm_bundles()` work everywhere a Bundle is evaluated.** Both the single-lookup `tm_bundle()` and the catalog-wide `tm_bundles()` are now available throughout Bundle definitions — including inside `define bundle lets`, exports, scaffolding paths, and stack metadata. A Bundle can look up other Bundles, cache the result in a let, and use it freely. Combined with the `bundle(...)` input type, this rounds out a small but coherent toolkit for Bundle-to-Bundle composition: declare the dependency, dereference it once, use it everywhere.
- **Cleaner error handling for missing references.** Earlier RCs would deadlock when `tm_bundle()` was called with a non-existent class. 0.17.1 returns a clean error message instead.

## What This Buys Bundle Authors in General

These improvements aren't specific to any particular Bundle layout — they apply to any Terramate Bundle catalog. The three benefits worth highlighting:

**Single source of truth.** Change how a value is built (a name, a path, a tag prefix), change it in one place. No more grep-and-replace across stack files hoping you caught them all.

**Real composition.** Bundle-to-Bundle references are no longer strings the author has to parse. With `bundle(...)` inputs and `tm_bundle()` / `tm_bundles()` callable from any Bundle context, a Bundle can hold a typed reference to another Bundle and walk its inputs and exports as a structured object — the way you'd expect.

**Readable definitions.** Stack files stop being walls of nested attribute access. A let-defined alias at the top of a Bundle does the same work HCL `locals` do in Terraform: hoist the common subexpressions, give them names, let the rest of the file read like prose.

## How This Plays Out in the Example Repo

To make the improvements concrete, we re-ran the same refactor exercise the previous two posts went through, on the [example bundles in `terramate-catalyst-examples`](https://github.com/terramate-io/terramate-catalyst-examples) — the same ECS Cluster, ECS Service, S3, account, and region Bundles we built at KubeCon.

A few representative wins from that refactor (these are example-repo specifics, not general Terramate features):

- The example ECS Cluster Bundle had `tm_slug(bundle.input.name.value)` appear in five places — `alias`, `scaffolding.path`, `scaffolding.name`, plus stack tags in three stack files. A single `bundle.let.name_slug` replaces all of them.
- The example ECS Service Bundle's stack file used to reach into its referenced cluster via `bundle.input.cluster.value.export.X.value` four times in component inputs. With a `cluster` let pointing at `bundle.input.cluster.value`, the rest of the file reads like normal HCL — `bundle.let.cluster.export.alb_name.value` and so on.
- The three stack files for the example cluster (VPC, ALB, cluster) used to carry near-identical 200-character `path` expressions. They now share a single `bundle.let.path_prefix` defined once at the Bundle level.

Across the six example Bundles, the refactor was net-shorter and considerably more readable. The point isn't the line count, though — it's that there's now an obvious right place for each piece of derived state.

## The Composition Story Across 0.17 and 0.17.1

Stacking the recent changes together gives Bundle authors a small, coherent set of building blocks:

1. **`bundle(...)` input type (0.17)** — Bundles reference each other as first-class values, not strings.
2. **`tm_bundle()` / `tm_bundles()` everywhere (0.17.1)** — look up and derive values from those references anywhere a Bundle is evaluated.
3. **`define bundle lets` (0.17.1)** — name and reuse the derived values.

Each is useful alone. Together they replace a category of workaround the original KubeCon post leaned on — encoding compound values as split-able strings, smuggling state through "passthrough" exports, asking the user the same question in different shapes. The composition story finally feels native to Terramate, rather than something you have to engineer around.

## What Developers Consuming Bundles Won't Notice

The thing about Bundle author improvements is that the consumer experience doesn't change. If you're scaffolding infrastructure rather than writing Bundles, 0.17.1 looks identical to 0.17 — the dropdowns work the same, the YAML files look the same, the generated stacks live in the same paths.

That's by design. The job of Bundle authors is to make sure consumers don't have to think about any of this. Each release that makes the author's job easier quietly raises the ceiling on what consumers can do without ever knowing why.

## Takeaway

Post one was about getting multi-account, multi-region infrastructure to work at all. Post two covered the release that closed the gap for the people who *use* Bundles. Post three covers the release that closes it for the people who *write* them. Same arc, opposite side of the API.

If you maintain a Bundle catalog of any size, 0.17.1 is the release where authoring starts feeling like real code — with locals, with composition, with one obvious place to change each thing.
