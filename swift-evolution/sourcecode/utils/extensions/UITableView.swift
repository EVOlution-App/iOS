import UIKit

extension UITableView {
    
    func registerNib<T: UITableViewCell>(withClass cellClass: T.Type) where T: ReusableCellIdentifiable {
        register(
            Config.Nib.loadNib(name: T.cellIdentifier),
            forCellReuseIdentifier: T.cellIdentifier
        )
    }
    
    func registerClass<T: UITableViewCell>(_ cellClass: T.Type) where T: ReusableCellIdentifiable {
        register(cellClass.self, forCellReuseIdentifier: cellClass.cellIdentifier)
    }
    
}
