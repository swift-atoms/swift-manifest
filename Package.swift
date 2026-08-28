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
        .library(
            name: "Manifest Test Support",
            targets: ["Manifest Test Support"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Manifest",
            dependencies: []
        ),
        .target(
            name: "Manifest Test Support",
            dependencies: [
                .target(name: "Manifest")
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Manifest Tests",
            dependencies: [
                .target(name: "Manifest"),
                .target(name: "Manifest Test Support"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
