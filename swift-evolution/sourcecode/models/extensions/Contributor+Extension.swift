import Foundation

// MARK: - Contributor Extension
extension Contributor {
    func picture(_ width: Int = 200) -> String {
        return "https://avatars.githubusercontent.com/\(self.value)?size=\(width)"
    }
}
