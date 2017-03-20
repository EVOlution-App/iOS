import Unbox

struct EvolutionService {

    typealias CompletionDetail = (_ error: Error?, _ proposal: String?) -> Swift.Void
    typealias CompletionEvolutions = (_ error: Error?, _ evolutions: [Evolution]?) -> Swift.Void
    
    static func listEvolutions(completion: @escaping CompletionEvolutions) {
        
        Service.requestList("/proposals") { (error, object) in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            if let list = object {
                let evolutions: [Evolution] = list.flatMap({ try? unbox(dictionary: $0) })
                completion(nil, evolutions)
            }
        }
    }
    
    static func detail(proposal: Evolution, completion: @escaping CompletionDetail) {
        guard let markdownURL = proposal.link else {
            return
        }
        
        Service.requestText(markdownURL) { error, text in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            completion(nil, text)
        }
    }
}
