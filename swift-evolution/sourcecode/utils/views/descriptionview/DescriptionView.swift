import UIKit

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
