import CommonLibrary
import Foundation

public typealias Version = String

public struct Status: Decodable {
  public let version: Version?
  public let state: StatusState
  public let start: Date?
  public let end: Date?

  enum CodingKeys: String, CodingKey {
    case version
    case state
    case start
    case end
  }

  public init(version: Version?, state: StatusState, start: Date?, end: Date?) {
    self.version = version
    self.state = state
    self.start = start
    self.end = end
  }
}

// MARK: - Codable Initializer

public extension Status {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    version = try container.decodeIfPresent(String.self, forKey: .version)

    let stateString = try container.decode(String.self, forKey: .state)
    let desiredState = RawState(stateString)

    state = if let validState = StatusState(rawValue: desiredState) {
      validState
    }
    else {
      .error
    }

    start = if let startDate = try container.decodeIfPresent(String.self, forKey: .start) {
      DateFormatter.format(from: startDate, style: .iso8601)
    }
    else {
      nil
    }

    end = if let endDate = try container.decodeIfPresent(String.self, forKey: .end) {
      DateFormatter.format(from: endDate, style: .iso8601)
    }
    else {
      nil
    }
  }
}

// MARK: - Computed Properties

public extension Status {
  var title: String {
    state.name
  }

  var subtitle: String {
    var subtitle = ""

    switch state {
    case .implemented:
      if let version {
        subtitle += "in: Swift \(version)"
      }

    case .activeReview,
         .scheduledForReview:
      subtitle = datesPeriodDescription

    default:
      break
    }

    return subtitle
  }
}

// MARK: - Hashable && Equatable

extension Status: Hashable, Equatable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(version)
    hasher.combine(state)
    hasher.combine(start)
    hasher.combine(end)
  }

  public static func == (lhs: Status, rhs: Status) -> Bool {
    lhs.version == rhs.version
      && lhs.state == rhs.state
      && lhs.start == rhs.start
      && lhs.end == rhs.end
  }
}

// MARK: - Private Computed Properties

private extension Status {
  var value: StatusState {
    state
  }

  var datesPeriodDescription: String {
    guard let start, let end else {
      return end?.dateDescription ?? ""
    }

    if start.month == end.month {
      return "\(start.dateDescription) - \(end.dayOrdinal)"
    }

    return "\(start.dateDescription) - \(end.dateDescription)"
  }
}

// MARK: - Date Extension

private extension Date {
  var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal

    return formatter
  }

  var dateComponents: DateComponents {
    let components: Set<Calendar.Component> = [.month, .day]
    return Calendar.current.dateComponents(components, from: self)
  }

  var dateDescription: String {
    var description = ""

    if let day = dateComponents.day {
      let dayNumeral = NSNumber(value: day)
      let dayOrdinal = numberFormatter.string(from: dayNumeral) ?? dayNumeral.stringValue

      let formatter = DateFormatter(for: .shortMonth)
      description += formatter.string(from: self)
      description += dayOrdinal
    }

    return description
  }

  var month: Int {
    dateComponents.month ?? 0
  }

  var day: Int {
    dateComponents.day ?? 0
  }

  var dayOrdinal: String {
    numberFormatter.string(from: NSNumber(value: day)) ?? ""
  }
}
