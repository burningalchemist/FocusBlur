// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FocusBlur",
    platforms: [.macOS(.v14)],
    products: [
        .executable(
            name: "FocusBlur",
            targets: ["FocusBlur"]
        )
    ],
    targets: [
        .executableTarget(
            name: "FocusBlur",
            dependencies: [],
            exclude: [
                "Info.plist",
                "FocusBlur.entitlements",
                "Assets.xcassets"
            ]
        )
    ]
)
