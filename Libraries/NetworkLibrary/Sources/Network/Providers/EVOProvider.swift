import Foundation
import ModelsLibrary

public final class EVOProvider: EVOProviderProtocol {
  private let networkProvider: NetworkProviderProtocol
  
  public init(networkProvider: NetworkProviderProtocol) {
    self.networkProvider = networkProvider
  }
  
  /// Fetch list of proposals
  /// - Returns: List of proposal objects
  public func proposals() async throws -> Proposals {
    do {
      return try await networkProvider.fetchContent(
        from: Constants.URL.proposals,
        object: Proposals.self
      )
    }
    catch {
      return []
    }
  }
  
  /// Fetch the proposal’s detail
  /// - Parameter proposal: Proposal to fetch the detail
  /// - Returns: String (markdown) content related to the proposal
  public func details(for proposal: Proposal) async throws -> String {
    let urlString = Constants.URL.details(for: proposal.identifierFormatted)
    
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }
    
    do {
      let request = URLRequest(url: url)
      let data = try await networkProvider.fetchData(from: request)
      
      guard let content = String(data: data, encoding: .utf8) else {
        throw URLError(.cannotDecodeRawData)
      }
      
      return content
    }
    catch {
      print(error.localizedDescription)
      return .empty
    }
  }
}
