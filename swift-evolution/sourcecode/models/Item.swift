import Foundation

// MARK: - Items

struct Contributor: ItemProtocol {
  var text: String
  var type: ItemType
  var value: String
}

struct License: ItemProtocol {
  var text: String
  var type: ItemType
  var value: String
}

struct Item: ItemProtocol {
  var text: String
  var type: ItemType
  var value: String = ""
}

struct Subscription: ItemProtocol {
  var text: String
  var type: ItemType
  var value: String
  var subscribed: Bool
}

// MARK: - ItemType

enum ItemType: String {
  case github = "github.com"
  case twitter = "twitter.com"
  case url
  case email
  case undefined
}

// MARK: - ItemProtocol

protocol ItemProtocol {
  var text: String { get set }
  var type: ItemType { get set }
  var value: String { get set }
}

extension ItemProtocol {
  var media: String {
    switch type {
    case .github, .twitter:
      "\(type.rawValue)/\(value)"
    default:
      value
    }
  }
}

// MARK: - Equatable

extension ItemProtocol where Self: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.text == rhs.text
  }
}
