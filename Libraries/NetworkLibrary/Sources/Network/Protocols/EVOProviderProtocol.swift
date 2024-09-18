import ModelsLibrary

public protocol EVOProviderProtocol: Sendable {
  func proposals() async throws -> Proposals
  func details(for proposal: Proposal) async throws -> String
}
