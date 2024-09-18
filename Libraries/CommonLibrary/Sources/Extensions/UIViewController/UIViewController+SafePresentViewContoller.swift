import UIKit

public extension UIViewController {
  /// Present safely the View Controller injected
  /// - Parameters:
  ///   - viewControllerToPresent: ViewController which will be presented
  ///   - flag: Show ViewController with animation
  ///   - completion: Completion trailing closure
  func safePresent(
    _ viewControllerToPresent: UIViewController,
    animated flag: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    topPresentedViewController.present(
      viewControllerToPresent,
      animated: flag,
      completion: completion
    )
  }
}
