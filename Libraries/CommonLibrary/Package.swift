// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Common Library",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "CommonLibrary",
      targets: [
        "CommonLibrary"
      ]
    )
  ],
  targets: [
    .target(
      name: "CommonLibrary",
      linkerSettings: [
        .linkedFramework("UIKit", .when(platforms: [.iOS]))
      ]
    )
  ]
)
