import UIKit

class Service {
    typealias CompletionObject = (_ error: Error?, _ object: Data?) -> Swift.Void
    typealias CompletionString = (_ error: Error?, _ string: String?) -> Swift.Void
    typealias CompletionListKeyValue = (_ error: Error?, _ listKeyValue: [[String: Any]]?) -> Swift.Void
    
    static func requestList(_ url: String, completion: @escaping CompletionListKeyValue) {
        guard url != "" else {
            return
        }
        
        let baseURL = "https://data.swift.org/swift-evolution\(url)"

        self.request(url: baseURL) { error, data in
            guard error == nil, let data = data else {
                print("error=\(String(describing: error))")
                completion(error, nil)
                
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    completion(nil, json)
                }
            }
            catch let error as NSError {
                completion(error, nil)
            }
        }
    }
    
    static func requestText(_ url: String, completion: @escaping CompletionString) {
        guard url != "" else {
            return
        }
        
        let baseURL = "https://raw.githubusercontent.com/apple/swift-evolution/master/proposals/\(url)"
        
        self.request(url: baseURL) { error, data in
            guard error == nil, let data = data else {
                print("error=\(String(describing: error))")
                completion(error, nil)
                
                return
            }

            if let content = String(data: data, encoding: .utf8) {
                completion(nil, content)
            }
        }
    }
    
    
    fileprivate static func request(url: String, completion: @escaping CompletionObject) {
        guard let baseURL = URL(string: url) else {
            return
        }
        
        var request: URLRequest = URLRequest(url: baseURL);
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                print("error=\(String(describing: error))")
                completion(error, nil)

                return
            }
            
            completion(nil, data)
        }
        
        task.resume()
    }
}


