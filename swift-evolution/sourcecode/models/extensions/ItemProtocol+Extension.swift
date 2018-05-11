import Foundation

extension ItemProtocol {
    var media: String {
        switch type {
        case .github, .twitter:
            return "\(type.rawValue)/\(value)"
        default:
            return value
        }
    }
}

// MARK: - Equatable
extension ItemProtocol where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.text == rhs.text
    }
}
