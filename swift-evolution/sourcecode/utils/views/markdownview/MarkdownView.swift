import MarkdownSyntax
import UIKit
import WebKit

final class MarkdownView: UIView {

    private var isReady = false
    private var contentSize = CGSize.zero
    
    private(set) lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "message")
        
        userContentController.addUserScript(
            WKUserScript(
                source: "if (typeof exports == 'undefined') { var exports = {} }",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: false
            )
        )

        userContentController.addUserScript(
            WKUserScript(
                source: "if (typeof github == 'undefined') { var github = new exports.GitHub(null) }",
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
        )

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(
            frame: bounds,
            configuration: configuration
        )
        
        return webView
    }()
    
    private var contentHeight: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: contentHeight)
    }
    
    private var markdownString: String?
    private var markdownHTML: String = ""
    
    weak var navigationDelegate: WKNavigationDelegate? {
        didSet {
            webView.navigationDelegate = navigationDelegate
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(webView)
        loadHTML()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func addRefreshControl(_ view: UIRefreshControl) {
        webView.scrollView.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor(named: "BgColor")
        
        setupWebViewConstraints()
        
        let size = bounds.size
        if !contentSize.equalTo(size) {
            contentSize = size
            loadHTML()
        }
    }
    
    private func setupWebViewConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor(named: "BgColor")
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    // MARK: - Markdown Loading
    
    func load(markdown content: String) {
        do {
            markdownString = content
            
            let markdown = try Markdown(text: content)
            var markdownHTML = try markdown.renderHtml()
            
            markdownHTML = markdownHTML.trimmingCharacters(in: .whitespacesAndNewlines)
            markdownHTML = markdownHTML.replacingOccurrences(of: "\n", with: "\\n")
            markdownHTML = markdownHTML.replacingOccurrences(of: "\"", with: "\\\"")
            markdownHTML = markdownHTML.replacingOccurrences(of: "'", with: "\\'")
            
            self.markdownHTML = markdownHTML
            loadMarkdownIntoHTML()
        }
        catch {
            print(error)
        }
    }
    
    private func loadHTML() {
        let templateHTML = MarkdownResources.shared.template
        
        webView.loadHTMLString(
            templateHTML,
            baseURL: nil
        )
    }
    
    private func loadMarkdownIntoHTML() {
        let javascript = String(format: "github.load('%@')", markdownHTML)
        
        webView.evaluateJavaScript(javascript) { [weak self] (height, _) in
            if let height = height as? CGFloat, let contentHeight = self?.contentHeight, height != contentHeight {
                self?.contentHeight = height
                self?.invalidateIntrinsicContentSize()
            }
        }
    }
}

// MARK: - WebKit Script Message Handler

extension MarkdownView: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "message",
            let body = message.body as? [String: Any],
            let messageName = body["messageName"] as? String else {
                return
        }
        
        switch messageName {
        case "ready":
            
            if let isReady = body["isReady"] as? Bool {
                self.isReady = isReady
            }
            
            if isReady {
                loadMarkdownIntoHTML()
            }
        
        case "height":
            if let height = body["height"] as? CGFloat, height != contentHeight {
                contentHeight = height
                invalidateIntrinsicContentSize()
            }
        
        default:
            return
        }
    }
    
}
