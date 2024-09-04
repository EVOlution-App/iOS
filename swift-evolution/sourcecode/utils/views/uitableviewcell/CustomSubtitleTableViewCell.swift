import UIKit

final class CustomSubtitleTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  var contributor: Contributor? {
    didSet {
      guard let contributor else {
        return
      }

      let placeholder = UIImage(named: "placeholder-photo")
      imageView?.image = placeholder

      textLabel?.text = contributor.text
      detailTextLabel?.text = contributor.media

      loadProfileImage()
    }
  }

  var license: License? {
    didSet {
      guard let license else {
        return
      }

      textLabel?.text = license.text
      detailTextLabel?.text = license.media
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    if let imageView {
      let currentSize = imageView.frame.size
      let size = CGSize(width: currentSize.width - 8, height: currentSize.height - 8)

      let currentOrigin = imageView.frame.origin
      let origin = CGPoint(x: currentOrigin.x, y: currentOrigin.y + 4)

      let frame = CGRect(origin: origin, size: size)
      imageView.frame = frame

      imageView.backgroundColor = UIColor.Proposal.lightGray.withAlphaComponent(0.5)
      imageView.round(with: UIColor.clear, width: 0)
    }
  }

  private func loadProfileImage() {
    guard let contributor, let imageView else {
      return
    }

    let url = contributor.picture(120)
    guard url != "" else {
      return
    }

    imageView.loadImage(from: url)
  }
}
