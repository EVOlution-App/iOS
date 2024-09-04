import SwiftUI

struct ListHeaderView: View {
  private let title: String

  init(count: Int) {
    let suffix = count != 1 ? "s" : ""
    title = "\(count) proposal\(suffix)"
  }

  init(title: String) {
    self.title = title
  }

  var body: some View {
    HStack(spacing: 10) {
      Text(title)
      Spacer()
    }
    .padding(.all, 10)
  }
}

#Preview("Empty", traits: .fixedLayout(width: 250, height: 50)) {
  ListHeaderView(count: 0)
}

#Preview("Counting", traits: .fixedLayout(width: 250, height: 50)) {
  ListHeaderView(count: 12)
}

#Preview("Custom title", traits: .fixedLayout(width: 250, height: 50)) {
  ListHeaderView(title: "No Proposals")
}
