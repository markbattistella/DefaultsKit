// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DefaultsKit",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .visionOS(.v1),
        .watchOS(.v9),
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
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "DefaultsKitTests",
            dependencies: ["DefaultsKit"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
