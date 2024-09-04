import UIKit.UIRefreshControl

extension UIRefreshControl {
  func forceShowAnimation() {
    DispatchQueue.main.async {
      guard let scrollView = self.superview as? UIScrollView else {
        return
      }

      let offSet = CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height)
      scrollView.setContentOffset(offSet, animated: true)

      self.beginRefreshing()
    }
  }
}
