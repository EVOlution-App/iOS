import UIKit

enum Method: String {
    case GET
    case POST
}

let swiftURLProposal = "https://data.swift.org/swift-evolution/proposals"
let githubBaseURLProposal = "https://github.com/apple/swift-evolution/blob/master/proposals"

class Service {
    
    typealias CompletionJSON = (_ error: Error?, _ json: Any?) -> Swift.Void
    
    static func request(_ url: String, method: Method, completion: @escaping CompletionJSON) {
        guard let url = URL(string: url) else {
            return
        }
        
        var request: URLRequest = URLRequest(url: url);
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil, let data = data else {
                    print("error=\(error)")
                    return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(nil, json)
                }
            }
            catch let error as NSError {
                completion(error, nil)
            }
        }
        
        task.resume()
    }
}


