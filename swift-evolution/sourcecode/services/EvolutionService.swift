import Unbox

struct EvolutionService {
    
    typealias CompletionDetail = (_ error: Error?, _ proposal: String?) -> Swift.Void
    typealias CompletionProposals = (_ error: Error?, _ proposals: [Proposal]?) -> Swift.Void
    
    static func listProposals(completion: @escaping CompletionProposals) {
        let baseURL = "https://data.swift.org/swift-evolution"

        Service.requestList("\(baseURL)/proposals") { (error, object) in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            if let list = object {
                let proposals: [Proposal] = list.flatMap({ try? unbox(dictionary: $0) })
                completion(nil, proposals)
            }
        }
    }
    
    static func detail(proposal: Proposal, completion: @escaping CompletionDetail) {
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
