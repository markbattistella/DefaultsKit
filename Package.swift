// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "DefaultsKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "DefaultsKit",
            targets: ["DefaultsKit"]
        )
    ],
    targets: [
        .target(
            name: "DefaultsKit",
            dependencies: [],
            exclude: [],
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)
