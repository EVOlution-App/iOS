import SwiftUI

extension View {
  /// Convert `View` to `UIView`
  /// - Returns: A `rootView` (`UIView`) from a `UIHostingController`
  @MainActor @preconcurrency func toUIView() -> UIView {
    UIHostingConfiguration { self }
      .makeContentView()
  }
}
