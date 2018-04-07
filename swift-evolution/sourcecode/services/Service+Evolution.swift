import Foundation

struct EvolutionService {
    
    typealias CompletionDetail = (ServiceResult<String>) -> Void
    typealias CompletionProposals = (ServiceResult<[Proposal]>) -> Void
    
    static func listProposals(completion: @escaping CompletionProposals) {
        let url = Config.Base.URL.Evolution.proposals
        let request = RequestSettings(url)

        Service.dispatch(request) { result in
            let newResult = result.flatMap { try JSONDecoder().decode([Proposal].self, from: $0) }
            completion(newResult)
        }
    }
    
    static func detail(for proposal: Proposal, completion: @escaping CompletionDetail) {
        let url = Config.Base.URL.Evolution.markdown(for: proposal.description)
        Service.requestText(url, completion: completion)
    }
}
