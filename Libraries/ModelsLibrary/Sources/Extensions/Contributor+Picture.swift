import Foundation

// MARK: - Contributor Extension

public extension Contributor {
  func picture(_ width: Int = 200) -> String {
    "https://avatars.githubusercontent.com/\(value)?size=\(width)"
  }
}
