import UIKit
import Reachability

class BaseViewController: UIViewController {
    public var reachability: Reachability?
    
    lazy var noConnectionView: NoConnectionView? = {
        guard
            let view: NoConnectionView = NoConnectionView.fromNib()
            else {
                return nil
        }
        
        return view
    }()
    
    public var rotate: Bool = false {
        didSet {
            (UIApplication.shared.delegate as? AppDelegate)?.rotate = rotate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        self.setupReachability()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable Rotation
        self.rotate = false
        
        // Force rotation back to portrait
        Config.Orientation.portrait()
    }
    
    deinit {
        self.stopNotifier()
    }
    
    // MARK: - Reachability
    private func setupReachability() {
        if let reachability = Reachability(hostname: "swift-evolution.io") {
            self.reachability = reachability
            
            reachability.whenReachable = { reachability in
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                }
                else if reachability.isReachableViaWWAN {
                   print("Reachable via WWAN")
                }
                else {
                    print("Reachable via Cellular")
                }
                
                DispatchQueue.main.async {
                    self.noConnectionView?.removeFromSuperview()
                }
            }
            
            reachability.whenUnreachable = { reachability in
                print("Network not reachable")
                
                if let noConnectionView = self.noConnectionView {
                    self.view.addSubview(noConnectionView)
                    
                    DispatchQueue.main.async {
                        noConnectionView.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            noConnectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                            noConnectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                            noConnectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                            noConnectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
                            ])
                    }
                }
            }
            
            self.startNotifier()
        }
    }
    
    private func startNotifier() {
        do {
            try self.reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func stopNotifier() {
        self.reachability?.stopNotifier()
    }
}
