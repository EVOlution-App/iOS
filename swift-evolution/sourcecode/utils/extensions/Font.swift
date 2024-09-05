//
//  Font.swift
//  swift-evolution
//
//  Created by Pedro Almeida on 05.09.24.
//  Copyright © 2024 EVO App. All rights reserved.
//

import SwiftUI
import enum SwiftRichString.SystemFonts

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
