import UIKit

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
