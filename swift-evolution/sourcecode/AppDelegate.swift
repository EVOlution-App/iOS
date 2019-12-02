import UIKit
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Private properties
    private var rotate: Bool = true
    
    // MARK: - Open properties
    var window: UIWindow?
    public var people: [String: Person] = [:]
    public var authorizedNotification: Bool = false
    
    // MARK: - Life Cycle
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = Navigation.shared
        application.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        registerSchemes()
        registerNetworkingMonitor()
        registerSizeOfCache()
        registerUser()
        
        // UI
        configSplitViewController()
        navigationBarAppearance()
        disableRotationIfNeeded()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        guard self.rotate else {
            return .portrait
        }
        
        return .allButUpsideDown
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
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
        guard let font = UIFont(name: "HelveticaNeue", size: 25) else {
            return
        }
        
        typealias Key = NSAttributedString.Key
        var attributes: [Key: Any]      = [:]
        attributes[.font]               = font
        attributes[.foregroundColor]    = UIColor.Proposal.darkGray
        
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
}

// MARK: - Registers
extension AppDelegate {

    private func registerNetworkingMonitor() {
        LoadingMonitor.register()
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
            case .authorized, .provisional:
                self?.authorizedNotification = true
            @unknown default:
                break
            }
        })
    }
    
    private func registerSchemes() {
        let routerHandler: Routes.CallbackHandler = { host, value in
            guard let host = Host(host), let value = value else {
                return
            }
            
            let navigation = Navigation.shared
            navigation.host = host
            navigation.value = value

            if UIApplication.shared.applicationState != .inactive || UIApplication.shared.applicationState != .background {
                NotificationCenter.default.post(
                    name: NSNotification.Name.URLScheme,
                    object: nil
                )
            }
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
    
    private func registerSizeOfCache() {
        URLCache.shared = {
            let memoryCapacity = 50 * 1024 * 1024
            let diskCapacity = 50 * 1024 * 1024
            
            return URLCache(memoryCapacity: memoryCapacity,
                            diskCapacity: diskCapacity,
                            diskPath: nil)
        }()
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
        print("[Remote Notification][Will Present] iOS 10: \(notification.request.content.userInfo)")
        completionHandler([.sound, .alert, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        trackNotification(with: response)
        completionHandler()
    }
}

// MARK: - Notifications
extension AppDelegate {
    private func trackNotification(with response: UNNotificationResponse) {
        guard let custom = response.customContent(), let currentUser = User.current else {
            return
        }
        
        if let url = try? response.deeplink() {
            Routes.shared.open(url)
        }
        
        let track = Notifications.Track(notification: custom.notification, user: currentUser.id, source: "ios")
        NotificationsService.track(track) { [track = custom] result in
            guard let response = result.value else {
                if let error = result.error {
                    print("Error: \(error)")
                    Crashlytics.sharedInstance().recordError(error)
                }
                return
            }
            
            let reportAttributes: [String: Any] = [
                "notification": track.notification,
                "type": track.type.rawValue,
                "value": track.value,
                "statusCode": response.statusCode
            ]
            
            guard response.statusCode == 201 else {
                if let reason = response.reason {
                    print("[AppDelegate][Tracking Notification] Error: \(reason)")
                    Crashlytics.sharedInstance().recordError(reason, withAdditionalUserInfo: reportAttributes)
                }
                return
            }
            
            Answers.logCustomEvent(withName: "Push Notification", customAttributes: reportAttributes)
        }
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
