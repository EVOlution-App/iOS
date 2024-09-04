import UIKit

public extension UIImageView {
  func round(with color: UIColor? = nil, width: CGFloat? = 0) {
    if let color {
      layer.borderColor = color.cgColor
    }

    if let width {
      layer.borderWidth = width
    }

    layer.cornerRadius = bounds.size.height / 2
    layer.masksToBounds = true
  }

  func loadImage(from url: String?) {
    guard let url, url.isEmpty == false else {
      return
    }

    Service.requestImage(url) { [weak self] result in
      guard let image = result.value else {
        return
      }

      DispatchQueue.main.async {
        self?.image = image
        self?.round()
      }
    }
  }
}
