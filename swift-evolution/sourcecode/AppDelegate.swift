import UIKit
import SVProgressHUD
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Private properties
    private var rotate: Bool = true
    
    // MARK: - Open properties
    var window: UIWindow?
    open var people: [String: Person] = [:]
    open var host: Host?
    open var value: String?
    open var authorizedNotification: Bool = false
    
    // MARK: - AppDelegate Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Register Fabric
        Fabric.with([Crashlytics.self])
        
        // Register User
        registerUser()
        
        // Network monitor
        registerNetworkingMonitor()

        configSplitViewController()
        navigationBarAppearance()
        
        // Register routes to use on URL Scheme
        registerSchemes()

        disableRotationIfNeeded()
        
        URLCache.shared = {
            let memoryCapacity = 50 * 1024 * 1024
            let diskCapacity = 50 * 1024 * 1024
            return URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: nil)
        }()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        guard self.rotate else {
            return .portrait
        }
        
        return .allButUpsideDown
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        Routes.shared.open(url)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       register(deviceToken)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Get Authorization to Notifications
        getAuthorizationStatus()
        NotificationCenter.default.post(name: Notification.Name.AppDidBecomeActive,
                                        object: nil)
    }
}

// MARK: - Appearance
extension AppDelegate {
    private func navigationBarAppearance() {
        let font = UIFont(name: "HelveticaNeue", size: 25)!
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.Proposal.darkGray]
    }
}

// MARK: - Registers
extension AppDelegate {

    private func registerNetworkingMonitor() {
        LoadingMonitor.register()
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    func registerForPushNotification() {
        let notification = UNUserNotificationCenter.current()
        notification.delegate = self
        
        notification.requestAuthorization(options: [.sound, .alert, .badge]) { _, error in
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func getAuthorizationStatus() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self?.authorizedNotification = false
            case .authorized:
                self?.authorizedNotification = true
            }
        })
    }
    
    private func registerSchemes() {
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
    
    private func registerUser() {
        CloudKitService.user { [weak self] result in
            switch result {
            case .success:
                self?.registerForPushNotification()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func register(_ deviceToken: Data) {
        guard let user = User.current else {
            return
        }
        
        guard let languageCode = Locale.current.languageCode else {
            return
        }
        
        guard authorizedNotification else {
            return
        }
        
        let modelIdentifier = UIDevice.current.modelIdentifier()
        let systemVersion = UIDevice.current.systemVersion
        let appVersion = Environment.Release.version
        
        var deviceTest = false
        #if INTERNAL
            deviceTest = true
        #endif
        
        let device = Notifications.Device(
            token: deviceToken.hexString,
            user: user.id,
            test: deviceTest,
            os: systemVersion,
            appVersion: appVersion,
            model: modelIdentifier,
            language: languageCode
        )
        
        NotificationsService.add(device) { result in
            switch result {
            case .success:
                print("[EVO Notification] [Add Device] Registration complete")
                
                NotificationCenter.default.post(name: Notification.Name.NotificationRegister,
                                                object: nil)
                
                
            case .failure(let error):
                print("[EVO Notification] [Add Device] Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Rotation
extension AppDelegate {

    func allowRotation() {
        self.rotate = true
    }

    func disableRotationIfNeeded() {
        self.rotate = UIDevice.current.userInterfaceIdiom == .pad
    }

}

// MARK: - User Notification Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("[Remote Notification][Received][Will Present] iOS 10: \(notification.request.content.userInfo)")
        completionHandler([.sound, .alert, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("[Remote Notification][Received][Received] iOS 10: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}

// MARK: - UISplitViewControllerDelegate
extension AppDelegate: UISplitViewControllerDelegate {

    func configSplitViewController() {
        guard
            let splitController = window?.rootViewController as? UISplitViewController,
            let navController = splitController.viewControllers.last as? UINavigationController,
            let topViewController = navController.topViewController
            else { return }
        topViewController.navigationItem.leftBarButtonItem = splitController.displayModeButtonItem
        splitController.delegate = self
        splitController.preferredDisplayMode = .allVisible
    }

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {

        guard
            let secondaryAsNavController = secondaryViewController as? UINavigationController,
            let detailController = secondaryAsNavController.topViewController as? ProposalDetailViewController
            else { return false }
        return detailController.proposal == nil
    }

}
