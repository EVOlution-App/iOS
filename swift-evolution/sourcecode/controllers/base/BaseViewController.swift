import UIKit
import Reachability

class BaseViewController: UIViewController {
    // MARK: - Public properties

    public var reachability: Reachability?
    
    public lazy var noConnectionView: NoConnectionView? = {
        guard
            let view: NoConnectionView = NoConnectionView.fromNib()
            else {
                return nil
        }
        
        return view
    }()
    
    public var showNoConnection: Bool = false {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.noConnectionView?.isHidden = !self.showNoConnection
            }
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupReachability()
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
        if let reachability = Reachability(hostname: "google.com") {
            self.configureReachabilityView()
            self.noConnectionView?.retryButton.addTarget(self, action: #selector(retryButtonAction(_:)), for: .touchUpInside)
            
            self.reachability = reachability
            self.startNotifier()
        }
    }
    
    private func startNotifier() {
        do {
            try self.reachability?.startNotifier()
        }
        catch {
            print("Unable to start notifier")
        }
    }
    
    private func stopNotifier() {
        self.reachability?.stopNotifier()
    }
    
    private func configureReachabilityView() {
        if let noConnectionView = self.noConnectionView {
            self.view.addSubview(noConnectionView)
            noConnectionView.isHidden = true

            noConnectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noConnectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                noConnectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                noConnectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                noConnectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
                ])
        }
    }
    
    // MARK: - Reachability Retry Action
    @objc open func retryButtonAction(_ sender: UIButton) {
    }
}
