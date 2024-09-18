// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Design Library",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "DesignLibrary",
      targets: [
        "DesignLibrary"
      ]
    )
  ],
  targets: [
    .target(
      name: "DesignLibrary",
      linkerSettings: [
        .linkedFramework("UIKit", .when(platforms: [.iOS]))
      ]
    )
  ]
)
