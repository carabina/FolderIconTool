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
        .package(path: "../FoundationKit"),
        .package(path: "../LoggerKit"),
        .package(path: "../CommandLineKit"),
        .package(path: "../CoreGraphicsKit")
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
        )
    ]
)
