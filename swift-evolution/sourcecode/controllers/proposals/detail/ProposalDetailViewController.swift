import UIKit
import WebKit
import Down
import Crashlytics

class ProposalDetailViewController: BaseViewController {
    
    // MARK: - IBOutlet connections
    @IBOutlet private weak var detailView: UIView!
    
    // MARK: - Private properties
    private var downView: DownView? = nil
    
    // MARK: - Public properties
    var proposal: Proposal? = nil
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rotate = true
        
        self.downView = try? DownView(frame: self.detailView.bounds, markdownString: "")
        self.downView?.navigationDelegate = self
        
        if let downView = self.downView {
            self.detailView.addSubview(downView)
        }
        
        self.getProposalDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.downView?.frame = self.detailView.frame
    }

    // MARK: - Networking
    fileprivate func getProposalDetail() {
        guard let proposal = self.proposal else {
            return
        }
        
        EvolutionService.detail(proposal: proposal) { [unowned self] error, data in
            guard error == nil, let data = data else {
                if let error = error {
                    Crashlytics.sharedInstance().recordError(error)
                }

                return
            }
            
            Answers.logContentView(withName: "Proposal Detail",
                                   contentType: "Load Detail from server",
                                   contentId: self.proposal?.link,
                                   customAttributes: nil)
            
            DispatchQueue.main.async {
                try? self.downView?.update(markdownString: data) {
                    print("Finished")
                }
            }
        }
    }
}

extension ProposalDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
        }
        
        decisionHandler(.allow)
    }
}
