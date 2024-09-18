import Foundation

// MARK: - ItemProtocol

public protocol ItemProtocol {
  var text: String { get set }
  var type: ItemType { get set }
  var value: String { get set }
}

public extension ItemProtocol {
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
