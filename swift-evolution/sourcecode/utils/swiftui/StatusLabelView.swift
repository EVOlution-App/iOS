//
//  StatusLabelView.swift
//  swift-evolution
//
//  Created by Pedro Almeida on 05.09.24.
//  Copyright © 2024 EVO App. All rights reserved.
//

import SwiftUI

struct StatusLabelView<Label: View>: View {
  @Binding
  var isOn: Bool

  @ViewBuilder
  var label: Label

  var selectedColor = Color(uiColor: .systemBackground)

  var normalColor = Color.secondary

  var body: some View {
    let foreground = isOn ? selectedColor : normalColor
    let background = isOn ? normalColor : .clear

    label
      .padding(EdgeInsets(x: 10, y: 3))
      .foregroundStyle(foreground)
      .background {
        let shape = RoundedRectangle(cornerRadius: 4)

        ZStack {
          shape.strokeBorder(.secondary)
          shape.fill(background)
        }
      }
  }
}

extension StatusLabelView where Label == Text {
  init<S: StringProtocol>(
    _ title: S,
    isOn: Binding<Bool>,
    selectedColor: Color? = nil,
    normalColor: Color? = nil
  ) {
    self.label = Text(title)
    self._isOn = isOn
    if let selectedColor {
      self.selectedColor = selectedColor
    }
    if let normalColor {
      self.normalColor = normalColor
    }
  }
}

#Preview {
  VStack {
    StatusLabelView_Preview(text: "Selected", isOn: true)
    StatusLabelView_Preview(text: "Unselected", isOn: false)
  }
}

struct StatusLabelView_Preview: View {
  var text: String
  @SwiftUI.State var isOn: Bool

  var body: some View {
    StatusLabelView(text, isOn: $isOn)
  }
}
