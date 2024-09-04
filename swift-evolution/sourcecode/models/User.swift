import Foundation
import KeychainAccess

struct User: Codable {
  let id: String
  let tags: [Notifications.Tag]?
  var notifications: Bool?
  let createdAt: Date?
  let updatedAt: Date?

  enum CodingKeys: String, CodingKey {
    case id = "ckID"
    case tags
    case createdAt
    case updatedAt
    case notifications
  }

  init(id: String, tags: [Notifications.Tag]? = nil, notifications: Bool = true) {
    self.id = id
    self.tags = tags
    self.notifications = notifications
    createdAt = nil
    updatedAt = nil
  }
}

extension User {
  static var current: User? {
    let bundleID = Environment.bundleID ?? "io.swift-evolution.app"
    let keychain = Keychain(service: bundleID).synchronizable(true)

    guard let token = try? keychain.getString("currentUser") else {
      return nil
    }

    return User(id: token)
  }
}
