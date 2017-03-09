import UIKit

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(withClass cellClass: T.Type) where T: ReusableCellIdentifiable {
        register(
            Config.Nib.loadNib(name: T.cellIdentifier),
            forCellWithReuseIdentifier: T.cellIdentifier
        )
    }
    
    func registerClass<T: UICollectionViewCell>(_ cellClass: T.Type) where T: ReusableCellIdentifiable {
        register(
            cellClass.self,
            forCellWithReuseIdentifier: cellClass.cellIdentifier
        )
    }
    
    func cell<T: ReusableCellIdentifiable>(forItemAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.cellIdentifier,
                                   for: indexPath) as! T
    }
    
}
