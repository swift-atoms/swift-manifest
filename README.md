# swift-manifest

Use this package when a tool reads a Swift source file as its configuration manifest, such as a `Lint.swift` at a package root whose value is bound to a name like `manifest`, and needs to describe where that file lives, which packages it may import, and which toolchain compiles it. Start from `Manifest.Configuration`, which holds the root, filename, binding and an optional toolchain, plus one `Manifest.Dependency` per package the manifest may import. To find the manifest a file inherits from, use `Manifest.Parent.scan(in:)`.

## Laws

- `Manifest.Parent.scan(in:)` looks only at the first 30 lines. Only a line feed (`0x0A`) ends a line, so a carriage return does not count towards the limit. The limit is the same whether or not the source ends with a line feed.
- A directive is a line that starts with exactly `// parent:`, case-sensitive, after any number of ASCII spaces or tabs. Unicode whitespace does not count as indentation, and text before the marker means the line is not a directive.
- The value starts after the spaces and tabs that follow the marker. It ends at the first space, tab or carriage return.
- A directive with an empty value is skipped. The first directive with a value wins.
- The value comes back as its original UTF-8 bytes. It is not decoded, normalised or checked against any URL scheme.
