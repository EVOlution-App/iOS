import Foundation

extension UUID {
  static var newIdentifier: String {
    UUID().uuidString
  }
}
