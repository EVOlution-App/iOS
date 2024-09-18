import UIKit

public extension UIViewController {
  var topPresentedViewController: UIViewController {
    guard let presentedViewController else {
      return self
    }

    return presentedViewController.topPresentedViewController
  }
}
