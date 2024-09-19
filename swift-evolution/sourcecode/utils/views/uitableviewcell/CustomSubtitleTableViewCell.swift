import SwiftUI
import UIKit

import ModelsLibrary

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

#if DEBUG

extension CustomSubtitleTableViewCell {
  static func create(_ contributor: Contributor) -> Self {
    let cell = Self.loadFromNib()
    cell.contributor = contributor

    return cell
  }

  static func create(_ license: License) -> Self {
    let cell = Self.loadFromNib()
    cell.license = license

    return cell
  }

  static func create(title: String, subtitle: String) -> Self {
    let cell = Self.loadFromNib()

    cell.textLabel?.text = title
    cell.detailTextLabel?.text = subtitle

    return cell
  }
}

#endif

#Preview("Author Cell", traits: .fixedLayout(width: 400, height: 50)) {
  CustomSubtitleTableViewCell.create(
    Contributor(
      text: "Thiago Holanda",
      type: .github,
      value: "unnamedd"
    )
  )
}

#Preview("Licenses Cell", traits: .fixedLayout(width: 400, height: 50)) {
  CustomSubtitleTableViewCell.create(
    License(
      text: "MarkdownSyntax",
      type: .github,
      value: "hebertialmeida/MarkdownSyntax"
    )
  )
}

#Preview("Contributors Cell", traits: .fixedLayout(width: 400, height: 50)) {
  CustomSubtitleTableViewCell.create(
    title: "Contributors, licenses and more",
    subtitle: "See all details about this app"
  )
}
