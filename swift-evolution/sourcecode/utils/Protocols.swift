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
  func didSelectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath)
  func didDeselectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath)
}

protocol FilterGenericViewLayoutDelegate: AnyObject {
  func didFinishCalculateHeightToView(type: FilterListGenericType, height: CGFloat)
}

// MARK: -

protocol ProposalDelegate: AnyObject {
  func didSelect(person: Person)
  func didSelect(proposal: Proposal)
  func didSelect(implementation: Implementation)
}

// MARK: - Enum Representable Protocols

protocol SegueRepresentable: RawRepresentable {
  func performSegue(in viewController: UIViewController?, split: Bool, formSheet: Bool)
  func performSegue(in viewController: UIViewController?, with object: Any?, split: Bool, formSheet: Bool)
}
