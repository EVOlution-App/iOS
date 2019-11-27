import UIKit

public extension UIColor {
    
    /**
        Colors for proposal status
    */
    struct Status {
        /**
         Color for status: **awaitingReview**
         */
        public static var awaitingReview: UIColor {
            return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        }
        
        /**
         Color for status: **scheduledForReview**
         */
        public static var scheduledForReview: UIColor {
            return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        }
        
        /**
         Color for status: **activeReview**
         */
        public static var activeReview: UIColor {
            return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        }
        
        /**
         Color for status: **returnedForRevision**
         */
        public static var returnedForRevision: UIColor {
            return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        }
        /**
         Color for status: **deferred**
         */
        public static var deferred: UIColor {
            return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        }
        
        /**
         Color for status: **accepted**
         */
        public static var accepted: UIColor {
            return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        }
        
        /**
         Color for status: **acceptedWithRevisions**
         */
        public static var acceptedWithRevisions: UIColor {
            return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        }
        
        /**
         Color for status: **rejected**
         */
        public static var rejected: UIColor {
            return UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        }
        
        /**
         Color for status: **implemented**
         */
        public static var implemented: UIColor {
            return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        }
        /**
         Color for status: **withdrawn**
         */
        public static var withdrawn: UIColor {
            return UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        }
    }
    

    /**
     Color for proposal elements on screen
     */
    struct Proposal {
        
        public static var lightGray: UIColor {
            return UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)
        }
        
        public static var darkGray: UIColor {
            return UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        }
    }
    
    struct Filter {
        public static var darkGray: UIColor {
            return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        }
    }
    
    struct Generic {
        static var darkGray: UIColor {
            return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        }
    }
}
