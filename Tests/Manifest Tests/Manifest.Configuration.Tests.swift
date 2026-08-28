import Manifest
import Testing

extension Manifest.Configuration {
    @Suite
    struct Test {
        @Suite struct Construction {}
    }
}

extension Manifest.Configuration.Test.Construction {
    @Test
    func `Configuration constructs with all parameters`() {
        let configuration = Manifest.Configuration(
            root: "/tmp/example",
            filename: "Lint.swift",
            binding: "manifest",
            dependencies: [
                Manifest.Dependency(
                    path: "/tmp/some-package",
                    name: "some-package",
                    product: "Some Product",
                    imports: ["Some_Product"]
                )
            ]
        )
        #expect(configuration.root == "/tmp/example")
        #expect(configuration.filename == "Lint.swift")
        #expect(configuration.binding == "manifest")
        #expect(configuration.dependencies.count == 1)
        #expect(configuration.toolchain == nil)
    }

    @Test
    func `Configuration accepts an explicit toolchain override`() {
        let configuration = Manifest.Configuration(
            root: "/tmp/example",
            filename: "Lint.swift",
            binding: "manifest",
            dependencies: [],
            toolchain: "/usr/bin/swift"
        )
        #expect(configuration.toolchain == "/usr/bin/swift")
    }
}
