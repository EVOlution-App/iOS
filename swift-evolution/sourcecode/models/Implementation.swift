import UIKit

enum ImplementationType: String, Codable {
  case commit
  case pull
}

struct Implementation: Decodable {
  let type: ImplementationType
  let identifier: String
  let repository: String
  let account: String

  enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case type
    case repository
    case account
  }
}

extension Implementation: CustomStringConvertible {
  var description: String {
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

  var path: String {
    "\(account)/\(repository)/\(type.rawValue)/\(identifier)"
  }
}

extension Implementation: Equatable {
  public static func == (lhs: Implementation, rhs: Implementation) -> Bool {
    lhs.path == rhs.path
  }
}
