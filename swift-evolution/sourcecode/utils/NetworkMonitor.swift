import Foundation
import UIKit

final class LoadingMonitor: URLProtocol {
  static let NetworkMonitorHandlerKey = "LoadingMonitorKey"

  static func register() {
    URLProtocol.registerClass(self)
  }

  static func unregister() {
    URLProtocol.unregisterClass(self)
  }

  override class func canInit(with request: URLRequest) -> Bool {
    guard property(forKey: NetworkMonitorHandlerKey, in: request) == nil else {
      return false
    }
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }

  override class func requestIsCacheEquivalent(_ firstRequest: URLRequest, to secondRequest: URLRequest) -> Bool {
    super.requestIsCacheEquivalent(
      firstRequest,
      to: secondRequest
    )
  }

  override func startLoading() {
    guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
      return
    }

    LoadingMonitor.setProperty(true, forKey: LoadingMonitor.NetworkMonitorHandlerKey, in: mutableRequest)

    let task = URLSession.shared.dataTask(with: mutableRequest as URLRequest) { data, _, error in
      if let error {
        self.client?.urlProtocol(self, didFailWithError: error)
        return
      }

      guard let data else {
        return
      }

      self.client?.urlProtocol(self, didLoad: data)
      self.client?.urlProtocolDidFinishLoading(self)
    }
    task.resume()
  }

  override func stopLoading() {}
}
