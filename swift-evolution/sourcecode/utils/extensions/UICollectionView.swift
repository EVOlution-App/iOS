import UIKit

extension UICollectionView {
  func registerNib<T: UICollectionViewCell>(withClass _: T.Type) {
    register(
      Config.Nib.loadNib(name: T.cellIdentifier),
      forCellWithReuseIdentifier: T.cellIdentifier
    )
  }

  func registerClass(_ cellClass: (some UICollectionViewCell).Type) {
    register(
      cellClass.self,
      forCellWithReuseIdentifier: cellClass.cellIdentifier
    )
  }

  func cell<T: ReusableCellIdentifiable>(forItemAt indexPath: IndexPath) -> T {
    dequeueReusableCell(
      withReuseIdentifier: T.cellIdentifier,
      for: indexPath
    ) as! T // swiftlint:disable:this force_cast
  }
}
