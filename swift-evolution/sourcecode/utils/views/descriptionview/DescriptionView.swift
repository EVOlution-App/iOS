import UIKit
import SwiftUI

protocol DescriptionViewProtocol: AnyObject {
  func closeAction()
}

final class DescriptionView: UIView {
  @IBOutlet private var versionLabel: UILabel!
  @IBOutlet private var appNameLabel: UILabel!
  @IBOutlet private var logoImageView: UIImageView!
  @IBOutlet private var closeButton: UIButton!

  weak var delegate: DescriptionViewProtocol?

  override func draw(_: CGRect) {
    if let version = Environment.Release.version,
       let build = Environment.Release.build
    {
      versionLabel.text = "v\(version) (\(build))"
    }

    closeButton.isHidden = UIDevice.current.userInterfaceIdiom != .pad
  }

  @IBAction private func dismiss(_: UIButton) {
    delegate?.closeAction()
  }
}

struct NewDescriptionView: View {
  var close: (() -> Void)?
  private let version = Environment.Release.version
  private let build = Environment.Release.build

  @ScaledMetric
  private var scale = 1

  var body: some View {
    VStack {
      Image("logo-evolution-splash")
        .frame(width: 126)

      Text(verbatim: "EVO App")
        .font(.custom("HelveticaNeue-Thin", size: scale * 36))

      if let version, let build {
        Text(verbatim: "v\(version) (\(build))")
          .font(.custom("HelveticaNeue-Light", size: scale * 17))
      }
    }
    .foregroundStyle(.secondary)
  }
}

struct CloseButtonModifier: ViewModifier {
  var close: (() -> Void)?

  func body(content: Content) -> some View {
    ZStack(alignment: .topTrailing) {
      content

      if let close {
        Button("Close", action: close).padding()
      }
    }
  }
}

#Preview {
  NewDescriptionView(close: {
    //..
  })
}
