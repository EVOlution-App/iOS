public extension Notifications {
  enum Kind: String, Codable {
    case bug
    case person
    case status
    case proposal
  }
}
