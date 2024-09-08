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

    Toggle(isOn: $isOn) {
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
    .toggleStyle(.button)
    .buttonStyle(_ButtonStyle())
  }

  private struct _ButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
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
    StatusLabelView_Preview(text: "Unselected")
  }
}

struct StatusLabelView_Preview: View {
  var text: String
  @State var isOn = false

  var body: some View {
    StatusLabelView(text, isOn: $isOn)
  }
}
