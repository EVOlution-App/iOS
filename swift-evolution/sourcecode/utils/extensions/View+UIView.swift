import SwiftUI

extension View {
  /// Convert `View` to `UIView`
  /// - Returns: A `rootView` (`UIView`) from a `UIHostingController`
  func toUIView() -> UIView {
    UIHostingController(
      rootView: self
    )
    .view
  }
}
