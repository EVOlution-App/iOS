import UIKit
import SwiftRichString
import SwiftUI

public enum FilterListGenericType {
  case status
  case version
  case none
}

class FilterListGenericView: UIView {
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var collectionView: UICollectionView!

  open weak var delegate: FilterGenericViewDelegate?
  open weak var layoutDelegate: FilterGenericViewLayoutDelegate?

  open var height: CGFloat = 0
  open var type: FilterListGenericType = .none
  open var selectedItems: [IndexPath] = []
  open var indexPathsForSelectedItems: [IndexPath]? {
    collectionView.indexPathsForSelectedItems
  }

  var dataSource: [CustomStringConvertible] = [] {
    didSet {
      reloadData()
    }
  }

  // MARK: - Initialization

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
    collectionView.allowsMultipleSelection = true
  }

  // MARK: - Util

  fileprivate func textFor(indexPath: IndexPath) -> String {
    var text: String
    let item = dataSource[indexPath.item]

    text = (item is String) ? "Swift \(item)" : item.description

    return text
  }

  // MARK: - Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    height = collectionView.contentSize.height + descriptionLabel.frame.maxY
    layoutDelegate?.didFinishCalculateHeightToView(type: type, height: height)
  }

  private func reloadData() {
    guard !dataSource.isEmpty else {
      return
    }

    DispatchQueue.main.async {
      self.collectionView.reloadData()
      self.collectionView.performBatchUpdates(nil) { _ in
        self.height = self.collectionView.contentSize.height + self.descriptionLabel.bounds.maxY
        self.layoutDelegate?.didFinishCalculateHeightToView(type: self.type, height: self.height)
      }
    }
  }
}

// MARK: - UICollectionView DataSource

extension FilterListGenericView: UICollectionViewDataSource {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    dataSource.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.contentConfiguration = UIHostingConfiguration(content: {
      StatusLabelView(
        textFor(indexPath: indexPath),
        isOn: .constant(selectedItems.contains(indexPath))
      ).fixedSize()
    })

    return cell
  }
}

// MARK: - UICollectionView Delegate

extension FilterListGenericView: UICollectionViewDelegate {
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectFilter(self, type: type, indexPath: indexPath)
  }

  func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    delegate?.didDeselectFilter(self, type: type, indexPath: indexPath)
  }
}

// MARK: - UICollectionView DelegateFlowLayout

extension FilterListGenericView: UICollectionViewDelegateFlowLayout {
  func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let text = textFor(indexPath: indexPath)
    let font = SystemFonts.HelveticaNeue.font(size: 16)
    let width = text.estimatedWidth(height: 28, font: font) + 34
    let size = CGSize(width: width, height: 28)
    return size
  }

  func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt _: Int) -> CGFloat
  {
    3
  }

  func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt _: Int
  ) -> CGFloat {
    3
  }
}
