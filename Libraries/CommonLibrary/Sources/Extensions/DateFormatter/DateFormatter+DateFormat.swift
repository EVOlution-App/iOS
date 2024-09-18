import Foundation

public extension DateFormatter {
  enum DateFormat {
    case iso8601
    case yearMonthDay
    case monthDay
    case shortMonth
    
    var dateFormat: String {
      switch self {
      case .iso8601:
        "yyyy-MM-dd'T'HH:mm:ss'Z'"
      case .yearMonthDay:
        "yyyy-MM-dd"
      case .monthDay:
        "MMMM dd"
      case .shortMonth:
        "MMM. "
      }
    }
  }
  
  static let monthDay: DateFormatter = formatter(for: .monthDay)
  static let shortMonth: DateFormatter = formatter(for: .shortMonth)
  
  static func format(from dateString: String, style: DateFormat) -> Date? {
    let formatter = formatter(for: style)
    
    return formatter.date(
      from: dateString
    )
  }
  
  convenience init(for style: DateFormat) {
    self.init()
    self.dateFormat = style.dateFormat
    self.locale = Locale(identifier: "en_US")
  }

  private static func formatter(for style: DateFormat) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = style.dateFormat
    formatter.locale = Locale(identifier: "en_US")
    
    return formatter
  }
}
