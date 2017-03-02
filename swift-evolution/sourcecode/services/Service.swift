import UIKit

class Service {
    typealias CompletionJSON = (_ error: Error?, _ json: Any?) -> Swift.Void
    
    static func request(_ url: String, completion: @escaping CompletionJSON) {
        guard let baseURL = URL(string: "https://data.swift.org/swift-evolution\(url)") else {
            return
        }
        
        var request: URLRequest = URLRequest(url: baseURL);
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                print("error=\(error)")
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
        
        task.resume()
    }
}


