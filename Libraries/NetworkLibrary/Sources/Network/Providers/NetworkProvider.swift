import Foundation

public actor NetworkProvider: NetworkProviderProtocol {
  public init() {}
  
  /// Fetch data from server and convert it into a Codable
  /// - Parameter url: Endpoint’s URL
  /// - Parameter object: Codable type which should be used in the conversion
  /// - Returns: Data converted into Codable protocol
  public func fetchContent<D: Decodable & Sendable>(from url: String, object: D.Type = D.self) async throws -> D {
    guard let url = URL(string: url) else {
      throw URLError(.badURL)
    }
    
    let request = URLRequest(url: url)
    let data = try await fetchData(from: request)
    
    let decoder = JSONDecoder()
    let model = try decoder.decode(object, from: data)
    
    return model
  }
  
  /// Fetch data from server
  /// - Parameter request: URLRequest for the server request
  /// - Returns: Data structure returned from the server
  public func fetchData(from request: URLRequest) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    return data
  }
}
