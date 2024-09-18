import UIKit.UIColor

extension UIColor {
  /**
       Colors for proposal status
   */
  public enum Status {
    /**
     Color for status: **awaitingReview**
     */
    public static var awaitingReview: UIColor {
      UIColor(red: 255 / 255, green: 149 / 255, blue: 0 / 255, alpha: 1)
    }

    /**
     Color for status: **scheduledForReview**
     */
    public static var scheduledForReview: UIColor {
      UIColor(red: 255 / 255, green: 149 / 255, blue: 0 / 255, alpha: 1)
    }

    /**
     Color for status: **activeReview**
     */
    public static var activeReview: UIColor {
      UIColor(red: 255 / 255, green: 149 / 255, blue: 0 / 255, alpha: 1)
    }

    /**
     Color for status: **returnedForRevision**
     */
    public static var returnedForRevision: UIColor {
      UIColor(red: 255 / 255, green: 149 / 255, blue: 0 / 255, alpha: 1)
    }

    /**
     Color for status: **deferred**
     */
    public static var deferred: UIColor {
      UIColor(red: 88 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
    }

    /**
     Color for status: **accepted**
     */
    public static var accepted: UIColor {
      UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
    }

    /**
     Color for status: **acceptedWithRevisions**
     */
    public static var acceptedWithRevisions: UIColor {
      UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
    }

    /**
     Color for status: **rejected**
     */
    public static var rejected: UIColor {
      UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1)
    }

    /**
     Color for status: **implemented**
     */
    public static var implemented: UIColor {
      UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1)
    }

    /**
     Color for status: **implemented**
     */
    public static var previewing: UIColor {
      UIColor(red: 0 / 255, green: 190 / 255, blue: 180 / 255, alpha: 1)
    }

    /**
     Color for status: **withdrawn**
     */
    public static var withdrawn: UIColor {
      UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1)
    }
  }
}
