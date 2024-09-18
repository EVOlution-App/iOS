import Foundation

public extension Notifications {
  struct Tag: Codable {
    public let id: String
    public let name: String
    public let identifier: String
    public let subscribed: Bool?

    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case name
      case identifier
      case subscribed
    }
  }
}
