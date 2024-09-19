import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import UIKit
import UserNotifications

import ModelsLibrary

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  // MARK: Private properties

  private var rotate: Bool = true

  // MARK: - Open properties

  var window: UIWindow?
  public var people: [String: Person] = [:]
  public var authorizedNotification: Bool = false

  // MARK: - Life Cycle

  func application(
    _: UIApplication,
    willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    _ = Navigation.shared
    UNUserNotificationCenter.current().setBadgeCount(0)

    return true
  }

  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppCenter.start(
      withAppSecret: "<AppCenter Key",
      services: [
        Analytics.self,
        Crashes.self,
      ]
    )

    registerSchemes()
    registerNetworkingMonitor()
    registerSizeOfCache()

    // FIXME: This will return when we stabilize push notifications again
    // registerUser()

    // UI
    configSplitViewController()
    navigationBarAppearance()
    disableRotationIfNeeded()

    return true
  }

  func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
    guard rotate else {
      return .portrait
    }

    return .allButUpsideDown
  }

  func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    Routes.shared.open(url)

    return true
  }

  func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    register(deviceToken)
  }

  func applicationDidBecomeActive(_: UIApplication) {
    // FIXME: This will return when we stabilize push notifications again
    // Get Authorization to Notifications
    // getAuthorizationStatus()
    NotificationCenter.default.post(
      name: Notification.Name.AppDidBecomeActive,
      object: nil
    )
  }
}

// MARK: - Appearance

extension AppDelegate {
  private func navigationBarAppearance() {
    guard let font = UIFont(name: "HelveticaNeue", size: 25) else {
      return
    }

    typealias Key = NSAttributedString.Key
    var attributes: [Key: Any] = [:]
    attributes[.font] = font
    attributes[.foregroundColor] = UIColor.Proposal.darkGray

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
    current.getNotificationSettings { [weak self] settings in
      switch settings.authorizationStatus {
      case .notDetermined,
           .denied:
        self?.authorizedNotification = false
      case .authorized,
           .provisional:
        self?.authorizedNotification = true
      default:
        break
      }
    }
  }

  private func registerSchemes() {
    let routerHandler: Routes.CallbackHandler = { host, value in
      guard let host = Host(host), let value else {
        return
      }

      let navigation = Navigation.shared
      navigation.host = host
      navigation.value = value

      if UIApplication.shared.applicationState != .inactive || UIApplication.shared
        .applicationState != .background
      {
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

      case let .failure(error):
        print(error.localizedDescription)
      }
    }
  }

  private func register(_ deviceToken: Data) {
    guard let user = User.current else {
      return
    }

    guard let languageCode = Locale.current.language.languageCode?.identifier else {
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
      user: user.identifier,
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

      case let .failure(error):
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
    rotate = true
  }

  func disableRotationIfNeeded() {
    rotate = UIDevice.current.userInterfaceIdiom == .pad
  }
}

// MARK: - User Notification Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _: UNUserNotificationCenter,
    willPresent _: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.sound, .badge])
  }

  func userNotificationCenter(
    _: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Swift.Void
  ) {
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

    let track = Notifications.Track(notification: custom.notification, user: currentUser.identifier, source: "ios")
    NotificationsService.track(track)
  }
}

// MARK: - UISplitViewControllerDelegate

extension AppDelegate: UISplitViewControllerDelegate {
  func configSplitViewController() {
    guard
      let splitController = window?.rootViewController as? UISplitViewController,
      let navController = splitController.viewControllers.last as? UINavigationController,
      let topViewController = navController.topViewController
    else {
      return
    }
    topViewController.navigationItem.leftBarButtonItem = splitController.displayModeButtonItem
    splitController.delegate = self
    splitController.preferredDisplayMode = .oneBesideSecondary
  }

  func splitViewController(_: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto _: UIViewController) -> Bool
  {
    guard
      let secondaryAsNavController = secondaryViewController as? UINavigationController,
      let detailController = secondaryAsNavController.topViewController as? ProposalDetailViewController
    else {
      return false
    }
    return detailController.proposal == nil
  }
}
