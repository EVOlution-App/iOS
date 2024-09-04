import Foundation

extension Notifications {
  enum `Type`: String, Codable {
    case bug
    case person
    case status
    case proposal
  }

  struct CustomContent: Codable {
    let notification: String
    let type: Type
    let value: String
  }
}
