// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DGCSHInspection",
	platforms: [.iOS(.v12), .macOS(.v10_15)],
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library( name: "DGCSHInspection",  targets: ["DGCSHInspection"]),
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(name: "DGCCoreLibrary", url: "https://github.com/eu-digital-green-certificates/dgca-verification-core-library-ios.git", .branch("main")),
        .package(name: "SwiftPath", url: "https://github.com/g-mark/SwiftPath.git", .branch("develop")),
        .package(name: "Sextant", url: "https://github.com/KittyMac/Sextant.git", from: "0.4.9"),
        .package(name: "SWCompression", url: "https://github.com/tsolomko/SWCompression.git", from: "4.7.0"),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", from: "5.5.0"),
        .package(name: "JOSESwift", url: "https://github.com/airsidemobile/JOSESwift.git", .branch("master")),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target( name: "DGCSHInspection",
            dependencies: ["DGCCoreLibrary", "SwiftPath", "Sextant", "SWCompression", "Alamofire", "JOSESwift"]),
        
        .testTarget(
            name: "DGCSHInspectionTests",
            dependencies: ["DGCSHInspection", "JOSESwift"]),
    ]
)
