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
        .library(name: "Manifest Standard Library Integration", targets: ["Manifest Standard Library Integration"]),
        .library(name: "Manifest Foundation Library Integration", targets: ["Manifest Foundation Library Integration"]),
        .library(name: "Manifest Test Support", targets: ["Manifest Test Support"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Manifest",
            dependencies: [
            ],
            path: "Sources/Manifest"
        ),
        .target(
            name: "Manifest Standard Library Integration",
            dependencies: [
                .target(name: "Manifest"),
            ],
            path: "Sources/Manifest Standard Library Integration"
        ),
        .target(
            name: "Manifest Foundation Library Integration",
            dependencies: [
                .target(name: "Manifest"),
                .target(name: "Manifest Standard Library Integration"),
            ],
            path: "Sources/Manifest Foundation Library Integration"
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
                .target(name: "Manifest Standard Library Integration"),
                .target(name: "Manifest Foundation Library Integration"),
            ],
            path: "Tests/Manifest Tests"
        ),
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
