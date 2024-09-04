import SwiftUI

struct AboutHeaderView: View {
  var title: String

  init(_ title: String) {
    self.title = title
  }

  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
        .textCase(.uppercase)
        .foregroundColor(.secondary)

      Spacer()
    }
    .padding(.horizontal, 10)
  }
}

#Preview(traits: .fixedLayout(width: 250, height: 50)) {
  AboutHeaderView("Contributors")
}
