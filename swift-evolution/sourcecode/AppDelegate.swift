import UIKit
import SVProgressHUD
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rotate: Bool = false
    
    open var people: [String: Person] = [:]
    open var host: Host?
    open var value: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LoadingMonitor.register()
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let font = UIFont(name: "HelveticaNeue-Thin", size: 25)!
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.Proposal.darkGray]
        
        Fabric.with([Crashlytics.self])
        
        // Register routes to use on URL Scheme
        let _ = Routes()
        self.registerSchemes()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        guard self.rotate else {
            return .portrait
        }
        
        return .allButUpsideDown
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Routes.shared.open(url)
        
        return true
    }
    
    func registerSchemes() {
        let routerHandler: CallbackHandler = { [weak self] host, value in
            guard let h = host, let host = Host(h), let value = value else {
                return
            }
            
            self?.host = host
            self?.value = value
            NotificationCenter.default.post(name: NSNotification.Name.URLScheme, object: nil, userInfo: ["Host": host, "Value": value])
        }
        
        // Register only URL hosts to Routes. URL example: evo://proposal/SE-0025
        Routes.shared.add("proposal", routerHandler)
        Routes.shared.add("profile", routerHandler)
    }
}

