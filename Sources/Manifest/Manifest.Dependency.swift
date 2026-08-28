extension Manifest {

    public struct Dependency: Swift.Sendable {

        public let path: Swift.String

        public let name: Swift.String

        public let product: Swift.String

        public let imports: [Swift.String]

        public init(
            path: Swift.String,
            name: Swift.String,
            product: Swift.String,
            imports: [Swift.String]
        ) {
            self.path = path
            self.name = name
            self.product = product
            self.imports = imports
        }
    }
}
