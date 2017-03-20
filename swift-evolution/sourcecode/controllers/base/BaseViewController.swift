import UIKit

class BaseViewController: UIViewController {

    public var rotate: Bool = false {
        didSet {
            (UIApplication.shared.delegate as? AppDelegate)?.rotate = rotate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
