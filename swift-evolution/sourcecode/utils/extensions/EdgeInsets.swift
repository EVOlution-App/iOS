//
//  EdgeInsets.swift
//  swift-evolution
//
//  Created by Pedro Almeida on 05.09.24.
//  Copyright © 2024 EVO App. All rights reserved.
//

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
