import enum SwiftRichString.SystemFonts
import SwiftUI

extension Font {
  /// Create a custom font with the given `name` and `size` that scales with
  /// the body text style.
  static func helveticaLight(size: CGFloat) -> Font {
    .custom(SystemFonts.HelveticaNeue_Light.rawValue, size: size)
  }

  static func helveticaThin(size: CGFloat) -> Font {
    .custom(SystemFonts.HelveticaNeue_Thin.rawValue, size: size)
  }
}
