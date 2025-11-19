// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "DefaultsKit",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v7),
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
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]

        )
    ]
)
