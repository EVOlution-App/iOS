import XCTest
import WebKit
import Down
@testable import swift_evolution

class MockWKNavigation: NSObject {
    
    var delegateCalled: Bool = false
    
}

extension MockWKNavigation: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.delegateCalled = true
    }
    
}

class ProposalDetailViewControllerTests: XCTestCase {
    
    var proposalDetailViewController: ProposalDetailViewController!
    var mockWebView: MockWKNavigation!
    var mockProposal: Proposal = Proposal(id: 0, link: "https://github.com/swift")
    var mockRequest: URLRequest = URLRequest(url: URL(string: "https://github.com/swift")!)
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.proposalDetailViewController = storyboard.instantiateViewController(withIdentifier: "ProposalDetailStoryboardID") as? ProposalDetailViewController
        _ = proposalDetailViewController.view
        self.mockWebView = MockWKNavigation()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanInstantiateProposalDetailViewController() {
        XCTAssertNotNil(proposalDetailViewController)
    }
    
    func testProposalDetailViewControllerViewDidLoad() {
        self.proposalDetailViewController.viewDidLoad()
        XCTAssertNotNil(proposalDetailViewController)
    }
    
    func testProposalDetailViewControllerViewWillAppear() {
        self.proposalDetailViewController.viewWillAppear(true)
        self.proposalDetailViewController.viewWillAppear(false)
        XCTAssertNotNil(proposalDetailViewController)
    }
    
    func testProposalDetailViewControllerDidReceiveMemoryWarning() {
        self.proposalDetailViewController.didReceiveMemoryWarning()
        XCTAssertNotNil(proposalDetailViewController)
    }
    
    func testConformsToWKNavigationDelegate () {
        XCTAssert(self.proposalDetailViewController.conforms(to: WKNavigationDelegate.self))
        XCTAssertTrue(proposalDetailViewController.responds(to: #selector(proposalDetailViewController.webView(_:decidePolicyFor:decisionHandler:))))
    }
    
    func testInstanceofDownView() {
         XCTAssertNotNil(self.proposalDetailViewController.downView)
    }
}
