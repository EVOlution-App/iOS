import UIKit

import ModelsLibrary

public enum FilterLevels {
  case without
  case filtered
  case status
  case version
}

class FilterHeaderView: UIView {
  @IBOutlet var statusFilterView: FilterListGenericView!
  @IBOutlet var languageVersionFilterView: FilterListGenericView!
  @IBOutlet var filteredByButton: UIButton!
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var filterButton: UIButton!

  @IBOutlet fileprivate var statusFilterViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate var languageVersionFilterViewHeightConstraint: NSLayoutConstraint!

  var filterLevel: FilterLevels = .without

  var statusSource: [StatusState] = [] {
    didSet {
      statusFilterView.type = .status
      statusFilterView.dataSource = statusSource
    }
  }

  var languageVersionSource: [String] = [] {
    didSet {
      languageVersionFilterView.type = .version
      languageVersionFilterView.dataSource = languageVersionSource
    }
  }

  var heightForView: CGFloat {
    var maxy: CGFloat = 0.0

    switch filterLevel {
    case .without:
      maxy = searchBar.frame.maxY

    case .filtered:
      maxy = filteredByButton.frame.maxY

    case .status:
      maxy = statusFilterView.frame.maxY

    case .version:
      maxy = languageVersionFilterView.frame.maxY
    }

    return maxy + 10
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    let text = concatText(
      texts: formatterColor(color: UIColor.darkGray, text: "Filtered by: "),
      formatterColor(color: UIColor(hex: 0x0088CC), text: "All Statuses")
    )

    filteredByButton.adjustsImageWhenHighlighted = false
    filteredByButton.setAttributedTitle(text, for: .normal)
    filteredByButton.setAttributedTitle(text, for: .highlighted)

    statusFilterView.layoutDelegate = self
    languageVersionFilterView.layoutDelegate = self
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let color = UIColor(named: "DivisorLine") ?? UIColor.clear

    set(
      to: .bottom,
      with: color
    )
  }

  func updateFilterButton(status: [StatusState]) {
    var label = "\(status.count) filters"

    if status.isEmpty {
      label = "All Statuses"
    }
    else if
      status.count == 1,
      let filter = status.first,
      filter == .implemented,
      let versionIndexPaths = languageVersionFilterView.indexPathsForSelectedItems,
      versionIndexPaths.isEmpty == false
    {
      let versions: [String] = versionIndexPaths.map { self.languageVersionSource[$0.item] }
      label = "\(filter.description) (\(versions.joined(separator: ", ")))"
    }
    else if status.isEmpty == false, status.count < 3 {
      label = status.map(\.description).joined(separator: ", ")
    }

    let text = concatText(
      texts: formatterColor(color: UIColor.darkGray, text: "Filtered by: "),
      formatterColor(color: UIColor(hex: 0x0088CC), text: label)
    )
    filteredByButton.setAttributedTitle(text, for: .normal)
    filteredByButton.titleLabel?.adjustsFontSizeToFitWidth = true
  }
}

// MARK: - FilterGenericViewLayout Delegate

extension FilterHeaderView: FilterGenericViewLayoutDelegate {
  func filterGenericView(
    _ filterView: UIView,
    didFinishCalculateHeightToView type: FilterListGenericType,
    height: CGFloat
  ) {
    switch type {
    case .status:
      statusFilterViewHeightConstraint.constant = height
      statusFilterView.setNeedsUpdateConstraints()

    case .version:
      languageVersionFilterViewHeightConstraint.constant = height
      languageVersionFilterView.setNeedsUpdateConstraints()

    case .none:
      statusFilterViewHeightConstraint.constant = height
      statusFilterView.setNeedsUpdateConstraints()
      languageVersionFilterViewHeightConstraint.constant = height
      languageVersionFilterView.setNeedsUpdateConstraints()
    }
  }
}

// MARK: - Text and Colors

extension FilterHeaderView {
  func formatterColor(color: UIColor, text: String) -> NSMutableAttributedString {
    let color = [
      NSAttributedString.Key.foregroundColor: color,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
    ]
    return NSMutableAttributedString(string: text, attributes: color)
  }

  func concatText(texts: NSAttributedString...) -> NSAttributedString {
    let combination = NSMutableAttributedString()
    _ = texts.map(combination.append)
    return combination
  }
}
