import UIKit

extension UIView {
    static func fromNib<T: UIView>(_ nibName: String? = nil) -> T? {
        let name = nibName ?? String(describing: self)
        
        if let nib = Bundle.main.loadNibNamed(name, owner: self, options: nil),
            let view = nib.first as? T,
            nib.count > 0 {
            
            return view
        }

        return nil
    }
}
