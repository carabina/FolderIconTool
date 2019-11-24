// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FolderIconTool",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "FolderIconTool",
            targets: ["FolderIconTool"]
        ),
        .library(
            name: "FolderIconKit",
            targets: ["FolderIconKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pvieito/CommandLineKit.git", .branch("master")),
        .package(url: "https://github.com/pvieito/LoggerKit.git", .branch("master")),
        .package(url: "https://github.com/pvieito/FoundationKit.git", .branch("master")),
        .package(url: "https://github.com/pvieito/CoreGraphicsKit.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "FolderIconTool",
            dependencies: ["FoundationKit", "LoggerKit", "CommandLineKit", "FolderIconKit"],
            path: "FolderIconTool"
        ),
        .target(
            name: "FolderIconKit",
            dependencies: ["FoundationKit", "CoreGraphicsKit"],
            path: "FolderIconKit"
        ),
        .testTarget(
            name: "FolderIconKitTests",
            dependencies: ["FoundationKit", "FolderIconKit"]
        )
    ]
)
