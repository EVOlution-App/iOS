import UIKit
import SVProgressHUD
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rotate: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LoadingMonitor.register()
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let font = UIFont(name: "HelveticaNeue-Thin", size: 25)!
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.Proposal.darkGray]
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        guard self.rotate else {
            return .portrait
        }
        
        return .allButUpsideDown
    }
}

