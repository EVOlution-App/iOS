import Foundation
import ModelsLibrary

public final class GitHubProvider: GitHubProviderProtocol {
  private let networkProvider: NetworkProviderProtocol
  
  public init(networkProvider: NetworkProviderProtocol) {
    self.networkProvider = networkProvider
  }
  
  public func profileDetails(from username: String) async throws -> GitHubProfile {
    do {
      return try await networkProvider.fetchContent(
        from: Constants.URL.githubProfile(for: username),
        object: GitHubProfile.self
      )
    }
    catch {
      throw error
    }
  }
}
