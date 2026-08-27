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
        .library(
            name: "Manifest",
            targets: ["Manifest"]
        ),
        .library(
            name: "Manifest Standard Library Integration",
            targets: ["Manifest Standard Library Integration"]
        ),
        .library(
            name: "Manifest Apple Foundation Integration",
            targets: ["Manifest Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Manifest",
            dependencies: []
        ),
        .target(
            name: "Manifest Standard Library Integration",
            dependencies: ["Manifest"]
        ),
        .target(
            name: "Manifest Apple Foundation Integration",
            dependencies: [
                "Manifest",
                "Manifest Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Manifest Tests",
            dependencies: ["Manifest"]
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
