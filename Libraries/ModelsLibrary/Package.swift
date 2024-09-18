// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Models Library",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "ModelsLibrary",
      targets: [
        "ModelsLibrary"
      ]
    )
  ],
  dependencies: [
    // Internal
    .package(
      path: "../../Libraries/CommonLibrary"
    ),

    // External
    .package(
      url: "https://github.com/kishikawakatsumi/KeychainAccess",
      from: "4.2.2"
    ),
  ],
  targets: [
    .target(
      name: "ModelsLibrary",
      dependencies: [
        // Internal
        .product(name: "CommonLibrary", package: "CommonLibrary"),

        // External
        .product(name: "KeychainAccess", package: "KeychainAccess"),
      ],
      linkerSettings: [
        .linkedFramework("UIKit", .when(platforms: [.iOS]))
      ]
    )
  ]
)
