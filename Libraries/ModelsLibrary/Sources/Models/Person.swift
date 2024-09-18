import Foundation

import CommonLibrary

public typealias People = [Person]

public struct Person: Decodable {
  public var identifier: String?
  public let name: String
  public let link: String
  public let username: String?

  public var github: GitHubProfile?
  public var asAuthor: Proposals?
  public var asManager: Proposals?

  enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case name
    case link
  }
}

// MARK: - Codable Initializer

public extension Person {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
    name = try container.decode(String.self, forKey: .name)
    link = try container.decode(String.self, forKey: .link)
    username = GitHubUserFormatter.format(unboxedValue: link)
  }
}

// MARK: - Hashable

extension Person: Hashable, Equatable {
  public static func == (lhs: Person, rhs: Person) -> Bool {
    lhs.identifier == rhs.identifier
      && lhs.name == rhs.name
      && lhs.link == rhs.link
      && lhs.username == rhs.username
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    hasher.combine(name)
    hasher.combine(link)
    hasher.combine(username)
  }
}

// MARK: - Searchable

extension Person: Searchable {}
