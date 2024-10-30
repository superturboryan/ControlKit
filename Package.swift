// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ControlKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Controllers",
            targets: ["Controllers"]),
        .library(
            name: "Control",
            targets: ["Control"]),
    ],
    dependencies: [
        .package(url: "https://github.com/spotify/ios-sdk.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "Controllers",
            dependencies: [
                "Control",
                .product(name: "SpotifyiOS", package: "ios-sdk")
            ]
        ),
        .target(
            name: "Control"
        )
    ]
)
