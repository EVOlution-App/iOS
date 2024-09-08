import SwiftUI

extension EdgeInsets {
  init(x horizontal: CGFloat, y vertical: CGFloat) {
    self.init(
      top: vertical,
      leading: horizontal,
      bottom: vertical,
      trailing: horizontal
    )
  }
}
