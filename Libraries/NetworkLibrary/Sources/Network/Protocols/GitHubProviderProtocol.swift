import ModelsLibrary

public protocol GitHubProviderProtocol: Sendable {
  func profileDetails(from username: String) async throws -> GitHubProfile
}
