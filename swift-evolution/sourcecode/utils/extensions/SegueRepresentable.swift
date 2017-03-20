import UIKit

// MARK: - SegueRepresentable Extension

extension SegueRepresentable where RawValue == String {
    func performSegue(in viewController: UIViewController) {
        self.performSegue(in: viewController, with: nil)
    }
    
    func performSegue(in viewController: UIViewController, with object: Any? = nil) {
        viewController.performSegue(withIdentifier: rawValue, sender: object)
    }
}
