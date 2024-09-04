import Reachability
import UIKit

class BaseViewController: UIViewController {
    // MARK: - Public properties

    var reachability: Reachability?

    lazy var noConnectionView: NoConnectionView? = NoConnectionView.fromNib()

    var showNoConnection: Bool = false {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                noConnectionView?.isHidden = !showNoConnection
            }
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
            configureReachabilityView()
            noConnectionView?.retryButton.addTarget(self, action: #selector(retryButtonAction(_:)), for: .touchUpInside)

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

    private func configureReachabilityView() {
        if let noConnectionView {
            view.addSubview(noConnectionView)
            noConnectionView.isHidden = true

            noConnectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noConnectionView.topAnchor.constraint(equalTo: view.topAnchor),
                noConnectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                noConnectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                noConnectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
    }

    // MARK: - Reachability Retry Action

    @objc open func retryButtonAction(_: UIButton) {}
}
