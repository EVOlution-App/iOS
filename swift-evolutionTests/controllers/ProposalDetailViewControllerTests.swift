@testable import swift_evolution
@preconcurrency import WebKit
import XCTest

class MockWKNavigation: NSObject {
  var delegateCalled: Bool = false
}

extension MockWKNavigation: WKNavigationDelegate {
  func webView(
    _: WKWebView,
    decidePolicyFor _: WKNavigationAction,
    decisionHandler _: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    delegateCalled = true
  }
}

class ProposalDetailViewControllerTests: XCTestCase {
  var proposalDetailViewController: ProposalDetailViewController!
  var mockWebView: MockWKNavigation!
  var mockProposal: Proposal = .init(identifier: 0, link: "https://github.com/swift")
  var mockRequest: URLRequest = .init(url: URL(string: "https://github.com/swift")!) // swiftlint:disable:this force_unwrapping

  override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    proposalDetailViewController = storyboard
      .instantiateViewController(withIdentifier: "ProposalDetailStoryboardID") as? ProposalDetailViewController
    _ = proposalDetailViewController.view
    mockWebView = MockWKNavigation()
  }

  func testCanInstantiateProposalDetailViewController() {
    XCTAssertNotNil(proposalDetailViewController)
  }

  func testProposalDetailViewControllerViewDidLoad() {
    proposalDetailViewController.viewDidLoad()
    XCTAssertNotNil(proposalDetailViewController)
  }

  func testProposalDetailViewControllerViewWillAppear() {
    proposalDetailViewController.viewWillAppear(true)
    proposalDetailViewController.viewWillAppear(false)
    XCTAssertNotNil(proposalDetailViewController)
  }

  func testProposalDetailViewControllerDidReceiveMemoryWarning() {
    proposalDetailViewController.didReceiveMemoryWarning()
    XCTAssertNotNil(proposalDetailViewController)
  }

  func testConformsToWKNavigationDelegate() {
    XCTAssert(proposalDetailViewController.conforms(to: WKNavigationDelegate.self))
    XCTAssertTrue(proposalDetailViewController
      .responds(to: #selector(proposalDetailViewController.webView(_:decidePolicyFor:decisionHandler:))))
  }
}
