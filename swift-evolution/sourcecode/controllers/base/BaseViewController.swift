import Reachability
import UIKit

class BaseViewController: UIViewController {
  // MARK: - Public properties

  var reachability: Reachability?

  private func noConnectionView() -> UIContentUnavailableConfiguration {
    var tryAgain = UIButton.Configuration.plain()
    tryAgain.title = "Try again"

    var configuration = UIContentUnavailableConfiguration.empty()
    configuration.image = UIImage(named: "bird-no-connection")
    configuration.text = "No internet connection"
    configuration.button = tryAgain
    configuration.buttonProperties.primaryAction = UIAction(
      title: "Try again",
      handler: retryButtonAction
    )

    return configuration
  }

  var showNoConnection: Bool = false {
    didSet {
      contentUnavailableConfiguration = showNoConnection ? noConnectionView() : nil
    }
  }

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()

    refreshControl.tintColor = UIColor.Generic.darkGray

    return refreshControl
  }()

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupReachability()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Disable Rotation for iPhones only
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.disableRotationIfNeeded()
    }

    // Force rotation back to portrait
    Config.Orientation.portrait()
  }

  deinit {
    self.stopNotifier()
  }

  // MARK: - Reachability

  private func setupReachability() {
    if let reachability = try? Reachability(hostname: "google.com") {
      self.reachability = reachability
      startNotifier()
    }
  }

  private func startNotifier() {
    do {
      try reachability?.startNotifier()
    }
    catch {
      print("Unable to start notifier")
    }
  }

  private func stopNotifier() {
    reachability?.stopNotifier()
  }

  // MARK: - Reachability Retry Action

  @objc open func retryButtonAction(_: UIAction) {}
}
