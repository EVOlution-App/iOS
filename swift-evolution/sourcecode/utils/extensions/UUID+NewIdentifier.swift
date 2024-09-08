import Foundation

// swiftlint:disable no_abbreviation_id
extension UUID {
  static var newIdentifier: String {
    UUID().uuidString
  }
}
// swiftlint:enable no_abbreviation_id
