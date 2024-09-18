// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Network Library",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "NetworkLibrary",
      targets: [
        "NetworkLibrary"
      ]
    )
  ],
  dependencies: [
    // Internal
    .package(
      path: "../../Libraries/CommonLibrary"
    ),
    .package(
      path: "../../Libraries/ModelsLibrary"
    ),
  ],
  targets: [
    .target(
      name: "NetworkLibrary",
      dependencies: [
        // Internal
        .product(name: "CommonLibrary", package: "CommonLibrary"),
        .product(name: "ModelsLibrary", package: "ModelsLibrary"),
      ]
    )
  ]
)
