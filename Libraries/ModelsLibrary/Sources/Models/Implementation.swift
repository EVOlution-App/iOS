import Foundation

public typealias Implementations = [Implementation]

public enum ImplementationType: String, Codable {
  case commit
  case pull
}

public struct Implementation: Decodable {
  public let type: ImplementationType
  public let identifier: String
  public let repository: String
  public let account: String

  enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case type
    case repository
    case account
  }
}

extension Implementation: CustomStringConvertible {
  public var description: String {
    var content = ""

    switch type {
    case .pull:
      content = "\(repository)#\(identifier)"

    case .commit:
      let index = identifier.index(identifier.startIndex, offsetBy: 7)
      let hash = identifier.prefix(upTo: index)

      content = "\(repository)@\(hash)"
    }
    return content
  }

  public var path: String {
    "\(account)/\(repository)/\(type.rawValue)/\(identifier)"
  }
}

// MARK: - Hashable && Equatable

extension Implementation: Hashable, Equatable {
  public static func == (lhs: Implementation, rhs: Implementation) -> Bool {
    lhs.identifier == rhs.identifier
      && lhs.type == rhs.type
      && lhs.repository == rhs.repository
      && lhs.account == rhs.account
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    hasher.combine(type)
    hasher.combine(repository)
    hasher.combine(account)
  }
}
