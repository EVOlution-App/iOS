import Unbox

struct EvolutionService {

    typealias CompletionEvolutions = (_ error: Error?, _ evolutions: [Evolution]?) -> Swift.Void
    
    static func listEvolutions(completion: @escaping CompletionEvolutions) {
        Service.request("/proposals") { (error, object) in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            if let list = object as? [[String: Any?]] {
                let evolutions: [Evolution] = list.flatMap({ try? unbox(dictionary: $0) })
                completion(nil, evolutions)
            }
        }
    }
}
