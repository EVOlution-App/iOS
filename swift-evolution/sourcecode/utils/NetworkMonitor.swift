//
//  NetworkMonitor.swift
//  swift-evolution
//
//  Created by Bruno Guidolim on 29/03/17.
//  Copyright © 2017 Holanda Mobile. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

final class LoadingMonitor: URLProtocol {
    
    static let NetworkMonitorHandlerKey = "LoadingMonitorKey"
    
    final class func register() {
        URLProtocol.registerClass(self)
    }
    
    final class func unregister() {
        URLProtocol.unregisterClass(self)
    }
    
    open override class func canInit(with request: URLRequest) -> Bool {
        guard property(forKey: NetworkMonitorHandlerKey, in: request) == nil else {
            return false
        }
        return true
    }
    
    final override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    final override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }

    override func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        SVProgressHUD.show()
    
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }
        
        LoadingMonitor.setProperty(true, forKey: LoadingMonitor.NetworkMonitorHandlerKey, in: mutableRequest)
        
        let task = URLSession.shared.dataTask(with: mutableRequest as URLRequest) { data, response, error in
            guard error == nil, let data = data else {
                self.client?.urlProtocol(self, didFailWithError: error!)
                return
            }
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }
    
    override func stopLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }
}
