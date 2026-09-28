// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-manifest",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Manifest", targets: ["Manifest"]),

        .library(name: "Manifest Foundation Integration", targets: ["Manifest Foundation Integration"]),
        .library(name: "Manifest Test Support", targets: ["Manifest Test Support"]),
    ],
    traits: [
        .trait(name: "Parser", description: "Absorbed Parser integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-ascii.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-parser.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Manifest",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii", condition: .when(traits: ["Parser"])),
                .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Parser"])),
                .product(name: "Parser", package: "swift-parser", condition: .when(traits: ["Parser"])),
    ],
            path: "Sources/Manifest"
        ),

        .target(
            name: "Manifest Foundation Integration",
            dependencies: [
                .target(name: "Manifest"),
            ],
            path: "Sources/Manifest Foundation Integration"
        ),
        .target(
            name: "Manifest Test Support",
            dependencies: [
                .target(name: "Manifest"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Manifest Tests",
            dependencies: [
                .target(name: "Manifest"),
                .target(name: "Manifest Test Support"),
                .target(name: "Manifest Foundation Integration"),
            ],
            path: "Tests/Manifest Tests"
        ),
        .testTarget(name: "Absorbed swift-manifest-byte-parser Manifest Byte Parser Tests", dependencies: [.target(name: "Manifest")], path: "Tests/Absorbed/swift-manifest-byte-parser/Manifest Byte Parser Tests"),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
