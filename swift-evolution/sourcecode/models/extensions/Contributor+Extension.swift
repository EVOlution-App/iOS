import Foundation

// MARK: - Contributor Extension
extension Contributor {
    func picture(_ width: Int = 200) -> String {
        return "https://avatars.githubusercontent.com/\(self.value)?size=\(width)"
    }
}
// MARK: - Equatable
extension Contributor: Equatable {
    static func == (lhs: Contributor, rhs: Contributor) -> Bool {
        return lhs.text == rhs.text
    }
}
