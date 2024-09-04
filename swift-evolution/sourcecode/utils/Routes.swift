import Foundation

final class Routes {
  public typealias CallbackHandler = (_ url: String?, _ value: String?) -> Swift.Void

  static let shared = Routes()
  private var routes = [String: CallbackHandler]()

  func add(_ path: String, _ fallback: @escaping CallbackHandler) {
    routes[path] = fallback
  }

  func open(_ url: URL) {
    guard let host = url.host, host != "" else {
      return
    }

    let paths = url.path.components(separatedBy: "/").filter { $0 != "" }
    if let callback = routes[host], let first = paths.first {
      callback(host, first)
    }
  }
}
