import UIKit
import SVProgressHUD
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    open var rotate: Bool = false
    
    open var people: [String: Person] = [:]
    open var host: Host?
    open var value: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register Fabric
        Fabric.with([Crashlytics.self])
        
        
        self.navigationBarAppearance()
        self.registerNetworkingMonitor()
        self.registerForPushNotification()
        
        // Register routes to use on URL Scheme
        _ = Routes()
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //print(deviceToken.hexString)
    }
}

// MARK: - Registers
extension AppDelegate {

    fileprivate func registerNetworkingMonitor() {
        LoadingMonitor.register()
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    fileprivate func navigationBarAppearance() {
        let font = UIFont(name: "HelveticaNeue", size: 25)!
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.Proposal.darkGray]
    }
    
    fileprivate func registerForPushNotification() {
        
        if #available(iOS 10.0, *) {
            let notification = UNUserNotificationCenter.current()
            notification.delegate = self
            
            notification.requestAuthorization(options: [.sound, .alert, .badge]) { _, error in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            let settings = UIUserNotificationSettings(types:  [.sound, .alert, .badge], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    fileprivate func registerSchemes() {
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


// MARK: - Remote Notifications - <= iOS 9
extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("[Remote Notification][Received] iOS 9: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("[Remote Notification][Failed] iOS 9: \(error.localizedDescription)")
    }
}

// MARK: - UNUserNotificationCenter Delegate - >= iOS 10
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("[Remote Notification][Received][Will Present] iOS 10: \(notification.request.content.userInfo)")
        completionHandler([.sound, .alert, .badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("[Remote Notification][Received][Received] iOS 10: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}
