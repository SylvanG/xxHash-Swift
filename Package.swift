// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


// Swift package won't correctly use compiler condition here, and it will compile xxh_x86dispatch.c file and throws error on arm64 device.
//var xxHashSources = ["./xxHash/xxhash.c"]
//
//#if (arch(x86_64) || arch(i386))
//xxHashSources.append("./xxHash/xxh_x86dispatch.c")
//#endif

// Note:
// 1. The arch(arm) platform condition doesn’t return true for ARM 64 devices. The arch(i386) platform condition returns true when code is compiled for the 32–bit iOS simulator.
// https://docs.swift.org/swift-book/ReferenceManual/Statements.html#ID538
// 2. Note that compiler directives in the Package.swift will only work for checks on the 'host' machine. This is the machine building the code rather than the one running it - known as the 'target'.
// https://www.polpiella.dev/platform-specific-code-in-swift-packages/
// 3. Preprocessors directives like #if os(macOS) work, but they are referencing the development machine and not the target platform.
// https://stackoverflow.com/questions/57651273/preprocessor-directives-not-working-in-package-swift


// Another solution is to use target dependency condition, but target dependency condition only support platform and doesn't support arch.

    
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
