import UIKit

// MARK: - Searchable Protocol

protocol Searchable {}

// MARK: - Reusable Protocol

protocol ReusableCellIdentifiable {
  static var cellIdentifier: String { get }
}

extension ReusableCellIdentifiable where Self: UITableViewCell {
  static var cellIdentifier: String {
    String(describing: self)
  }
}

extension ReusableCellIdentifiable where Self: UICollectionViewCell {
  static var cellIdentifier: String {
    String(describing: self)
  }
}

extension UITableViewCell: ReusableCellIdentifiable {}
extension UICollectionViewCell: ReusableCellIdentifiable {}

// MARK: - FilterGenericView Delegate

protocol FilterGenericViewDelegate: AnyObject {
  func filterGenericView(_ view: FilterListGenericView, didSelectFilter type: FilterListGenericType, at indexPath: IndexPath)
  func filterGenericView(_ view: FilterListGenericView, didDeselectFilter type: FilterListGenericType, at indexPath: IndexPath)
}

protocol FilterGenericViewLayoutDelegate: AnyObject {
  func filterGenericView(_ filterView: UIView, didFinishCalculateHeightToView type: FilterListGenericType, height: CGFloat)
}

// MARK: - Enum Representable Protocols

protocol SegueRepresentable: RawRepresentable {
  func performSegue(in viewController: UIViewController?, split: Bool, formSheet: Bool)
  func performSegue(in viewController: UIViewController?, with object: Any?, split: Bool, formSheet: Bool)
}
