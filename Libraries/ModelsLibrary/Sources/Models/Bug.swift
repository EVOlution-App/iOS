import Foundation

public typealias Bugs = [Bug]

public struct Bug: Codable {
  public   let identifier: String
  public   let link: String

  enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case link
  }
}

// MARK: - Hashable && Equatable

extension Bug: Hashable, Equatable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    hasher.combine(link)
  }

  public static func == (lhs: Bug, rhs: Bug) -> Bool {
    lhs.identifier == rhs.identifier &&
      lhs.link == rhs.link
  }
}
