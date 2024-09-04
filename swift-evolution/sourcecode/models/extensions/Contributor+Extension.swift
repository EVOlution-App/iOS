import Foundation

// MARK: - Contributor Extension

extension Contributor {
    func picture(_ width: Int = 200) -> String {
        "https://avatars.githubusercontent.com/\(value)?size=\(width)"
    }
}
