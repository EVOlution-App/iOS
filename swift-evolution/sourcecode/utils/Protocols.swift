import UIKit

// MARK: - Reusable Protocol
protocol ReusableCellIdentifiable {
    static var cellIdentifier: String { get }
}

extension ReusableCellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
}

extension ReusableCellIdentifiable where Self: UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}


extension UITableViewCell: ReusableCellIdentifiable {}
extension UICollectionViewCell: ReusableCellIdentifiable {}

// MARK: - FilterGenericView Delegate
protocol FilterGenericViewDelegate: class {
    func didSelectedFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath)
    func didDeselectedFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath)
}

protocol FilterGenericViewLayoutDelegate: class {
    func didFinishedCalculateHeightToView(type: FilterListGenericType, height: CGFloat)
}

// MARK: - Enum Representable Protocols

protocol SegueRepresentable: RawRepresentable {
    func performSegue(in viewController: UIViewController)
    func performSegue(in viewController: UIViewController, with object: Any?)
}
