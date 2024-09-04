import UIKit

extension UITableView {
  func registerNib<T: UITableViewCell>(withClass _: T.Type) {
    register(
      Config.Nib.loadNib(name: T.cellIdentifier),
      forCellReuseIdentifier: T.cellIdentifier
    )
  }

  func registerClass(_ cellClass: (some UITableViewCell).Type) {
    register(cellClass.self, forCellReuseIdentifier: cellClass.cellIdentifier)
  }

  func cell<T: ReusableCellIdentifiable>(forRowAt indexPath: IndexPath) -> T {
    dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as! T
  }

  func cell<T: ReusableCellIdentifiable>(forClass _: T.Type = T.self) -> T {
    dequeueReusableCell(withIdentifier: T.cellIdentifier) as! T
  }
}
