import Foundation
import KeychainAccess

public struct User: Codable {
  public let identifier: String
  public let tags: [Notifications.Tag]?
  public var notifications: Bool?
  public let createdAt: Date?
  public let updatedAt: Date?

  enum CodingKeys: String, CodingKey {
    case identifier = "ckID"
    case tags
    case createdAt
    case updatedAt
    case notifications
  }

  public init(identifier: String, tags: [Notifications.Tag]? = nil, notifications: Bool = true) {
    self.identifier = identifier
    self.tags = tags
    self.notifications = notifications
    createdAt = nil
    updatedAt = nil
  }
}

public extension User {
  static var current: User? {
    let bundleIdentifier = "io.swift-evolution.app"
    let keychain = Keychain(service: bundleIdentifier).synchronizable(true)

    guard let token = try? keychain.getString("currentUser") else {
      return nil
    }

    return User(identifier: token)
  }
}
