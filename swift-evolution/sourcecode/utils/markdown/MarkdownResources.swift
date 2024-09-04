import Foundation

final class MarkdownResources {
  private lazy var markdownBundleURL: URL = {
    guard let bundle = Bundle.main.url(forResource: "Markdown", withExtension: "bundle") else {
      fatalError("Markdown.bundle was not found")
    }

    return bundle
  }()

  private lazy var cascadingStyleSheetContent: String = {
    let cssURL = self.markdownBundleURL.appendingPathComponent("markdown.css")

    guard let styleSheetContent = try? String(contentsOf: cssURL) else {
      fatalError("markdown.css was not found")
    }

    return styleSheetContent
  }()

  private lazy var syntaxCSSContent: String = {
    let cssURL = self.markdownBundleURL.appendingPathComponent("syntax.css")

    guard let styleSheetContent = try? String(contentsOf: cssURL) else {
      fatalError("markdown.css was not found")
    }

    return styleSheetContent
  }()

  private lazy var javascriptContent: String = {
    let javascriptURL = self.markdownBundleURL.appendingPathComponent("markdown.js")

    guard let javascriptContent = try? String(contentsOf: javascriptURL) else {
      fatalError("markdown.js was not found")
    }

    return javascriptContent
  }()

  private lazy var templateContent: String = {
    let templateURL = self.markdownBundleURL.appendingPathComponent("template.html")

    guard let templateContent = try? String(contentsOf: templateURL) else {
      fatalError("template.html was not found")
    }

    return templateContent
  }()

  static let shared = MarkdownResources()

  lazy var template = String(format: templateContent, cascadingStyleSheetContent, syntaxCSSContent, javascriptContent)

  private init() {}
}
