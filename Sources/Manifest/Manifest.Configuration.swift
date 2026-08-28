extension Manifest {

    public struct Configuration: Swift.Sendable {

        public let root: Swift.String

        public let filename: Swift.String

        public let binding: Swift.String

        public let dependencies: [Dependency]

        public let toolchain: Swift.String?

        public init(
            root: Swift.String,
            filename: Swift.String,
            binding: Swift.String,
            dependencies: [Dependency],
            toolchain: Swift.String? = nil
        ) {
            self.root = root
            self.filename = filename
            self.binding = binding
            self.dependencies = dependencies
            self.toolchain = toolchain
        }
    }
}
