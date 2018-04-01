import Foundation

struct EvolutionService {
    
    typealias CompletionDetail = (ServiceResult<String>) -> Void
    typealias CompletionProposals = (ServiceResult<[Proposal]>) -> Void
    
    static func listProposals(completion: @escaping CompletionProposals) {
        Service.request(url: "\(Config.Base.URL.data)/proposals") { (result) in
            let newResult = result.flatMap { try JSONDecoder().decode([Proposal].self, from: $0) }
            completion(newResult)
        }
    }
    
    static func detail(proposal: Proposal, completion: @escaping CompletionDetail) {
        let url = "\(Config.Base.URL.data)/proposal/\(proposal.description)/markdown"
        Service.requestText(url, completion: completion)
    }
}
