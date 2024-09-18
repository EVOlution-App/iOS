import Foundation

public extension Notifications {
  struct Device: Codable {
    let token: String
    let user: String
    let test: Bool?
    let os: String?
    let appVersion: String?
    let model: String?
    let language: String?
    var createdAt: Date? = nil
    var updatedAt: Date? = nil

    public init(
      token: String,
      user: String,
      test: Bool?,
      os: String?,
      appVersion: String?,
      model: String?,
      language: String?,
      createdAt: Date? = nil,
      updatedAt: Date? = nil
    ) {
      self.token = token
      self.user = user
      self.test = test
      self.os = os
      self.appVersion = appVersion
      self.model = model
      self.language = language
      self.createdAt = createdAt
      self.updatedAt = updatedAt
    }
  }
}
