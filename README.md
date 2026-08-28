# swift-manifest

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Foundation-clean abstractions for the `Manifest` namespace. Owns the
pure value types and parsing primitives that
[`swift-manifests`](https://github.com/swift-foundations/swift-manifests)
(the L3 manifest loader and chain resolver) consumes.

## Quick Start

Scan a manifest source file's leading comment lines for a
`// parent: <URL>` directive:

```swift
import Manifest

let source: [UInt8] = Array("// parent: https://example.com/Lint.swift\n".utf8)

if let parentURLBytes = Manifest.Parent.scan(in: source) {
    // Hand the bytes to a URI parser at L2 to validate scheme + structure.
    // This package returns raw bytes only — typing is the consumer's concern.
}
```

The scanner is pure, returns raw URL bytes (no allocation, no
validation), and depends only on the ASCII and parser-literal
primitives. Scheme validation, URI construction, fetching, and chain
composition are all higher-layer concerns.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-manifest.git", branch: "main"),
]
```

> Pre-1.0: no version tags yet. APIs may change; pin a commit for reproducible builds.

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Manifest", package: "swift-manifest"),
    ]
)
```

## What's in the namespace

| Type | Purpose |
|---|---|
| `Manifest` | Top-level namespace declaration. |
| `Manifest.Parent.scan(in:)` | Pure byte-level scanner for `// parent: <URL>` directives in a manifest's leading comment lines. Returns raw URL bytes; consumers handle scheme validation and URI construction. |
| `Manifest.Dependency` | A SwiftPM dependency description used by a higher-layer driver shim's eval project. Pure struct of strings — `path`, `name`, `product`, `imports`. |
| `Manifest.Configuration` | Aggregates the inputs needed to load a manifest (root path, filename, binding name, dependencies, optional toolchain) as a single value the consumer can store and reuse. |

Each type is a passive value: `Sendable`, no I/O, no global state, no
external SDK dependencies.

## Foundation-clean

This package imports no `Foundation`, no networking module, no
filesystem module, no JSON encoder/decoder. Its only dependencies are
two sibling primitives packages —
[`swift-ascii`](https://github.com/swift-atoms/swift-ascii)
and
[`swift-parser`](https://github.com/swift-atoms/swift-parser) —
which carry the same constraint.

The constraint exists because the higher-layer modules that build on
this package (the L3 loader's subprocess-based eval pipeline, the L3
resolver's URI fetcher and chain composition) need to be re-composable
across deployment platforms with different system libraries. A clean
L1 surface lets each higher-layer module choose its own Foundation /
URI / filesystem stack independently.

## Intended consumers

[`swift-manifests`](https://github.com/swift-foundations/swift-manifests)
is the primary consumer:

- `Manifest Loader` consumes `Manifest.Configuration` as the input
  value to its `Manifest.load(_:configuration:)` entry point and
  `Manifest.Dependency` as the dep description it materializes into a
  generated eval `Package.swift`.
- `Manifest Resolver` consumes `Manifest.Parent.scan(in:)` to extract
  parent-directive URL bytes from each layer's source file before
  fetching the next ancestor in the chain.

Third-party tools that take Swift-DSL configuration files (a
hypothetical `swift-format-extended`, a custom build-tool config layer,
a documentation-pipeline manifest) can adopt the same primitives
without depending on `swift-manifests` itself when their loader and
resolver mechanics differ.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
