import Foundation

public extension Notifications {
  struct CustomContent: Codable {
    public let notification: String
    public let type: Kind
    public let value: String
  }
}
