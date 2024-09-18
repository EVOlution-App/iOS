import Foundation

public struct Response: Codable {
  public let statusCode: Int
  public let reason: String?

  enum CodingKeys: String, CodingKey {
    case statusCode
    case reason
  }
}
