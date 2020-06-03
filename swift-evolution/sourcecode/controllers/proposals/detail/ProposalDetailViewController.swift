import UIKit
import WebKit
import Down
import SafariServices

final class ProposalDetailViewController: BaseViewController {
    
    // MARK: - IBOutlet connections
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private var noSelectedProposalLabel: UILabel?

    // MARK: - Private properties
    private weak var appDelegate: AppDelegate?
    private var proposalMarkdown: String?
    private var shareButton: UIBarButtonItem?
    internal private(set) var downView: DownView?

    // MARK: - Public properties
    var proposal: Proposal?
    
    // MARK: - Reachability Retry Action
    override func retryButtonAction(_ sender: UIButton) {
        super.retryButtonAction(sender)
        
        getProposalDetail()
    }
}

// MARK: - Life cycle
extension ProposalDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title                               = proposal?.description
        appDelegate                         = UIApplication.shared.delegate as? AppDelegate
        noSelectedProposalLabel?.isHidden   = proposal?.description != nil
        navigationItem.leftBarButtonItem    = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        configureDownView()
        configureReachability()
        refreshControl.addTarget(self, action: #selector(getProposalDetail), for: .valueChanged)
        
        getProposalDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Allow rotation
        (UIApplication.shared.delegate as? AppDelegate)?.allowRotation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Reachability Closures
extension ProposalDetailViewController {
    
    private func configureReachability() {
        reachability?.whenReachable = { [weak self] reachability in
            if self?.proposalMarkdown == nil {
                self?.getProposalDetail()
            }
        }
        
        reachability?.whenUnreachable = { [weak self] reachability in
            if self?.proposalMarkdown == nil {
                self?.showNoConnection = true
            }
        }
    }
}

// MARK: - Elements
extension ProposalDetailViewController {
    internal func configureDownView() {
        guard let url = Bundle.main.url(forResource: "DownView", withExtension: "bundle"),
            let bundle = Bundle(url: url) else {
            return
        }

        self.downView = try? DownView(frame: self.detailView.bounds, markdownString: "", templateBundle: bundle)
        self.downView?.navigationDelegate = self
        self.downView?.scrollView.addSubview(refreshControl)
        
        if let downView = self.downView {
            self.detailView.addSubview(downView)
            downView.translatesAutoresizingMaskIntoConstraints = false
         
            NSLayoutConstraint.activate([
                downView.topAnchor.constraint(equalTo: self.detailView.topAnchor),
                downView.bottomAnchor.constraint(equalTo: self.detailView.bottomAnchor),
                downView.leadingAnchor.constraint(equalTo: self.detailView.leadingAnchor),
                downView.trailingAnchor.constraint(equalTo: self.detailView.trailingAnchor)
            ])
        }
    }
}

// MARK: - Networking
extension ProposalDetailViewController {
    @objc
    fileprivate func getProposalDetail() {
        guard let proposal = self.proposal else {
            return
        }
        
        if let reachability = self.reachability, reachability.connection != .none {
            // Hide No Connection View
            showNoConnection = false
            
            refreshControl.forceShowAnimation()
            EvolutionService.detail(for: proposal) { [weak self] result in
                guard let self = self else {
                    return
                }
                
                guard let data = result.value else {
                    return
                }
                
                self.proposalMarkdown = data
                
                DispatchQueue.main.async {
                    try? self.downView?.update(markdownString: data)
                    self.refreshControl.beginRefreshing()
                    self.showHideNavigationButtons()
                }
                
                // Remove refresh control
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
        else {
            showNoConnection = true
        }
    }
}

// MARK: - Navigation
extension ProposalDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProposalDetailViewController,
            let destination = segue.destination as? ProposalDetailViewController,
            sender != nil, let item = sender as? Proposal {

            destination.proposal = item
        }
        else if segue.destination is ProfileViewController,
            let destination = segue.destination as? ProfileViewController,
            sender != nil, sender is Person, let person = sender as? Person {
            
            destination.profile = person
        }
    }
    
}

// MARK: - Share Proposal
extension ProposalDetailViewController {
    @objc private func shareProposal() {
        guard let proposal = self.proposal else {
            return
        }
        
        let title = proposal.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = "Hey, check this proposal: \"\(title)\""
        let url = "https://evoapp.io/proposal/\(proposal.description)"
        
        let activityController = UIActivityViewController(activityItems: [content, url], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad, let sourceView = shareButton?.value(forKey: "view") as? UIView {
            activityController.modalPresentationStyle = .popover
            if let popoverPresentationController = activityController.popoverPresentationController {
                popoverPresentationController.sourceView = sourceView
                var bounds = sourceView.bounds
                bounds.origin.x = 10
                popoverPresentationController.sourceRect = bounds
            }
            self.navigationController?.present(activityController, animated: true, completion: nil)
        } else {
            self.navigationController?.present(activityController, animated: true, completion: nil)
        }
    }

    private func showHideNavigationButtons() {
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareProposal))
        navigationController?.navigationBar.topItem?.setRightBarButton(shareButton, animated: true)
    }
}

// MARK: - WKNavigation Delegate
extension ProposalDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url, let proposal = self.proposal else {
                decisionHandler(.allow)
                return
            }
            
            let lastPathComponent = url.lastPathComponent
            
            // Extract proposal info from selected anchor
            if url.path.hasSuffix(".md") {
                let list = lastPathComponent.components(separatedBy: "-")
                
                if let first = list.first, list.count > 0 {
                    
                    // Only load if the proposal touched isn't the same presented
                    if let id = Int(first), id != proposal.id {
                        let proposal = Proposal(id: id, link: lastPathComponent)
                        
                        Config.Segues.proposalDetail.performSegue(in: self, with: proposal)
                    }
                }
                    
                    // In case of url lastPathComponent has .md suffix and it isn't a proposal
                else {
                    let safariViewController = SFSafariViewController(url: url)
                    self.present(safariViewController, animated: true)
                }
            }

                // Check if the link is an author/review manager, if yes, send user to profile screen
            else if let host = url.host, host.contains("github.com"),
                let person = self.appDelegate?.people.get(username: lastPathComponent) {

                Config.Segues.profile.performSegue(in: self, with: person, formSheet: true)
            }
                
                // The last step is check only if the url "appears" to be correct, before try to send it to safari
            else if let scheme = url.scheme, ["http", "https"].contains(scheme.lowercased()) {
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true)
            }
            
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
