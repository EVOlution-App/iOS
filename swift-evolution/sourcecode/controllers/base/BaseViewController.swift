import UIKit

class BaseViewController: UIViewController {

    public var rotate: Bool = false {
        didSet {
            (UIApplication.shared.delegate as? AppDelegate)?.rotate = rotate
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable Rotation
        self.rotate = false
        
        // Force rotation back to portrait
        Config.Orientation.portrait()
    }
}
