import Foundation

extension UUID {
  
  /// Syntax sugar to generate an unique hash
  public static var newIdentifier: String {
    UUID()
      .uuidString
      .replacingOccurrences(
        of: "-",
        with: ""
      )
      .lowercased()
  }
}
