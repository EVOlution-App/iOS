import Foundation
import UIKit

final class LoadingMonitor: URLProtocol {
    static let NetworkMonitorHandlerKey = "LoadingMonitorKey"

    final class func register() {
        URLProtocol.registerClass(self)
    }

    final class func unregister() {
        URLProtocol.unregisterClass(self)
    }

    override public class func canInit(with request: URLRequest) -> Bool {
        guard property(forKey: NetworkMonitorHandlerKey, in: request) == nil else {
            return false
        }
        return true
    }

    override final class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override final class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        super.requestIsCacheEquivalent(a, to: b)
    }

    override func startLoading() {
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }

        LoadingMonitor.setProperty(true, forKey: LoadingMonitor.NetworkMonitorHandlerKey, in: mutableRequest)

        let task = URLSession.shared.dataTask(with: mutableRequest as URLRequest) { data, _, error in
            guard error == nil, let data else {
                self.client?.urlProtocol(self, didFailWithError: error!)
                return
            }
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }

    override func stopLoading() {}
}
