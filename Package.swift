// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


// Swift package won't correctly use compiler condition here, and it will compile xxh_x86dispatch.c file and throws error on arm64 device.
//var xxHashSources = ["./xxHash/xxhash.c"]
//
//#if (arch(x86_64) || arch(i386))
//xxHashSources.append("./xxHash/xxh_x86dispatch.c")
//#endif

// Another solution is to use target dependency, but target dependency only support platform and doesn't support arch.

    
let package = Package(
    name: "xxHash-Swift",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "xxHash-Swift",
            targets: ["xxHash-Swift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "xxHash",
            sources: ["./xxHash/xxhash.c"]),
        .target(
            name: "xxHash-Swift",
            dependencies: ["xxHash"]),
        .testTarget(
            name: "xxHash-SwiftTests",
            dependencies: ["xxHash-Swift"]),
    ]
)
