// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlayerEngine",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PlayerEngine",
            targets: ["PlayerEngine"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/tomislaveric/http-request.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PlayerEngine",
            dependencies: [
                .product(name: "HTTPRequest", package: "http-request")
            ]),
        .testTarget(
            name: "PlayerEngineTests",
            dependencies: [
                "PlayerEngine",
                .product(name: "HTTPRequest", package: "http-request")
            ]),
    ]
)
