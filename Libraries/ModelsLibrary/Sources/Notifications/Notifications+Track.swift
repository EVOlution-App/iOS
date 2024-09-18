import Foundation

public extension Notifications {
  struct Track: Codable {
    let notification: String
    let user: String
    let source: String

    public init(notification: String, user: String, source: String) {
      self.notification = notification
      self.user = user
      self.source = source
    }
  }
}
