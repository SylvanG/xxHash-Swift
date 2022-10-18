// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


var xxHashSources = [
    "./xxHash/xxhash.c",
]


#if XXH_X86DISPATCH_USE
print("use XXH_X86DISPATCH")
    xxHashSources.append("./xxHash/xxh_x86dispatch.c")
#endif

    
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
            sources: xxHashSources),
        .target(
            name: "xxHash-Swift",
            dependencies: ["xxHash"]),
        .testTarget(
            name: "xxHash-SwiftTests",
            dependencies: ["xxHash-Swift"],
            cSettings: [
                .define("XXH_X86DISPATCH_USE", to: "1")
            ]
        ),
    ]
)
