// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Attributed",
    platforms: [
        .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "Attributed", targets: ["Attributed"])
    ],
    targets: [
        .target(
            name: "Attributed",
            path: "Attributed"
        ),
        .testTarget(
            name: "AttributedTests",
            dependencies: ["Attributed"],
            path: "AttributedTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
