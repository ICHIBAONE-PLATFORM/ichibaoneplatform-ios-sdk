// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ichibaoneplatform-ios-sdk",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ichibaoneplatform-ios-sdk",
            targets: ["Core", "FCM"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "Core",
            path: "ichibaoneplatform-ios-sdk/Core",
            exclude: [],
            resources: [],
            publicHeadersPath: nil
        ),
        .target(
            name: "FCM",
            dependencies: [
                "Core",
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ],
            path: "ichibaoneplatform-ios-sdk/FCM",
            exclude: [],
            resources: [],
            publicHeadersPath: nil
        )
    ]
)
