import Unbox

struct EvolutionService {
    
    typealias CompletionDetail = (_ error: Error?, _ proposal: String?) -> Swift.Void
    typealias CompletionProposals = (_ error: Error?, _ proposals: [Proposal]?) -> Swift.Void
    
    static func listProposals(completion: @escaping CompletionProposals) {
        Service.requestList("\(Config.Base.URL.data)/proposals") { (error, object) in
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
        guard let markdown = proposal.link else {
            return
        }
        
        let url = "\(Config.Base.URL.proposal)/\(markdown)"
        
        Service.requestText(url) { error, text in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            completion(nil, text)
        }
    }
}
