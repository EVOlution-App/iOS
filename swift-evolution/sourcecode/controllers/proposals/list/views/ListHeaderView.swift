import SwiftUI

struct ListHeaderView: View {
  private let color: UIColor?
  private let title: String

  init(count: Int) {
    let suffix = count != 1 ? "s" : ""
    title = "\(count) proposal\(suffix)"
    color = count > 0 ? UIColor(named: "SecBgColor") : UIColor(named: "BgColor")
  }

  init(title: String) {
    self.title = title
    color = UIColor(named: "BgColor")
  }

  var body: some View {
    HStack(spacing: 10) {
      Text(title)
      Spacer()
    }
    .padding(.all, 10)
    .background(Color(uiColor: color ?? .clear))
  }
}

#Preview("Empty") {
  ListHeaderView(count: 0)
}

#Preview("Counting") {
  ListHeaderView(count: 12)
}

#Preview("Custom title") {
  ListHeaderView(title: "No Proposals")
}
