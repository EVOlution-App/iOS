import Foundation
import KeychainAccess

struct User: Codable {
  let identifier: String
  let tags: [Notifications.Tag]?
  var notifications: Bool?
  let createdAt: Date?
  let updatedAt: Date?

  enum CodingKeys: String, CodingKey {
    case identifier = "ckID"
    case tags
    case createdAt
    case updatedAt
    case notifications
  }

  init(identifier: String, tags: [Notifications.Tag]? = nil, notifications: Bool = true) {
    self.identifier = identifier
    self.tags = tags
    self.notifications = notifications
    createdAt = nil
    updatedAt = nil
  }
}

extension User {
  static var current: User? {
    let bundleIdentifier = Environment.bundleIdentifier ?? "io.swift-evolution.app"
    let keychain = Keychain(service: bundleIdentifier).synchronizable(true)

    guard let token = try? keychain.getString("currentUser") else {
      return nil
    }

    return User(identifier: token)
  }
}
