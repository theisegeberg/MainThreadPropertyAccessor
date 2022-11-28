// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "MainThreadPropertyAccessor"

let package = Package(
    name: packageName,
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    targets: [
        .target(name: packageName),
        .testTarget(name: "MainThreadPropertyAccessorTests", dependencies: [.byName(name: packageName)]),
    ]
)
