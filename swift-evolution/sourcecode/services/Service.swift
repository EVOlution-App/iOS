import UIKit

class Service {
    typealias CompletionObject = (_ error: Error?, _ object: Data?) -> Swift.Void
    typealias CompletionString = (_ error: Error?, _ string: String?) -> Swift.Void
    typealias CompletionImage = (_ error: Error?, _ string: UIImage?) -> Swift.Void
    typealias CompletionKeyValue = (_ error: Error?, _ keyValue: [String: Any]?) -> Swift.Void
    typealias CompletionListKeyValue = (_ error: Error?, _ listKeyValue: [[String: Any]]?) -> Swift.Void
    
    static func requestList(_ url: String, completion: @escaping CompletionListKeyValue) {
        guard url != "" else {
            return
        }
        
        self.request(url: url) { error, data in
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
    
    static func requestKeyValue(_ url: String, completion: @escaping CompletionKeyValue) {
        guard url != "" else {
            return
        }
        
        self.request(url: url) { error, data in
            guard error == nil, let data = data else {
                print("error=\(String(describing: error))")
                completion(error, nil)
                
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
    
    static func requestImage(_ url: String, completion: @escaping CompletionImage) {
        guard url != "", let URL = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.downloadTask(with: URL) { location, response, error in
            guard error == nil, let location = location else {
                print("error=\(String(describing: error))")
                completion(error, nil)
                
                return
            }
            
            guard let data = try? Data(contentsOf: location),
                let image = UIImage(data: data) else {
                    print("error=Failed to load image from \(location)")
                    return
            }
            completion(nil, image)
        }
        
        task.resume()
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


