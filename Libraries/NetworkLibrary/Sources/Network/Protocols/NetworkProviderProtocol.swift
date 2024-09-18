import Foundation

public protocol NetworkProviderProtocol: Sendable {
  func fetchContent<D: Decodable & Sendable>(from url: String, object: D.Type) async throws -> D
  func fetchData(from request: URLRequest) async throws -> Data
}
