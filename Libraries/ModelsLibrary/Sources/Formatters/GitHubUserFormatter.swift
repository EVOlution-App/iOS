import Foundation

enum GitHubUserFormatter {
  static func format(unboxedValue: String?) -> String? {
    guard let unboxedValue else {
      return nil
    }
    
    let values = unboxedValue.components(separatedBy: "/").filter { $0 != "" }
    
    if values.isEmpty == false, let value = values.last {
      return value
    }

    return nil
  }
}
