import UIKit

typealias Version = String

struct Status: Decodable {
  let version: Version?
  let state: StatusState
  let start: Date?
  let end: Date?

  enum CodingKeys: String, CodingKey {
    case version
    case state
    case start
    case end
  }
}

extension Status {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    version = try container.decodeIfPresent(String.self, forKey: .version)

    let stateString = try container.decode(String.self, forKey: .state)
    let desiredState = RawState(stateString)

    guard let validState = StatusState(rawValue: desiredState) else {
      throw ServiceError.invalidResponse
    }
    state = validState

    let dateFormatter = Config.Date.Formatter.yearMonthDay
    if let startDate = try container.decodeIfPresent(String.self, forKey: .start) {
      start = dateFormatter.date(from: startDate)
    }
    else {
      start = nil
    }

    if let endDate = try container.decodeIfPresent(String.self, forKey: .end) {
      end = dateFormatter.date(from: endDate)
    }
    else {
      end = nil
    }
  }
}
