import Foundation

public typealias Discussions = [Discussion]

public struct Discussion: Decodable {
  public let link: String
  public let name: String
}

// MARK: - Hashable && Equatable

extension Discussion: Hashable, Equatable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(link)
    hasher.combine(name)
  }

  public static func == (lhs: Discussion, rhs: Discussion) -> Bool {
    lhs.link == rhs.link &&
      lhs.name == rhs.name
  }
}
