import UIKit

struct Bug: Codable {
  let id: Int
  let status: String?
  let updated: Date?
  let title: String?
  let link: String?
  let radar: String?
  let assignee: String?
  let resolution: String?

  enum Keys: String, CodingKey {
    case id
    case status
    case title
    case link
    case radar
    case resolution
    case assignee
    case updated
  }
}

extension Bug {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    status = try container.decodeIfPresent(String.self, forKey: .status)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    link = try container.decodeIfPresent(String.self, forKey: .link)
    radar = try container.decodeIfPresent(String.self, forKey: .radar)
    assignee = try container.decodeIfPresent(String.self, forKey: .assignee)
    resolution = try container.decodeIfPresent(String.self, forKey: .resolution)
    let idString = try container.decode(String.self, forKey: .id)
    id = BugIDFormatter.format(unboxedValue: idString)
    if let dateString = try container.decodeIfPresent(String.self, forKey: .updated) {
      let dateFormatter = Config.Date.Formatter.iso8601
      updated = dateFormatter.date(from: dateString)
    }
    else {
      updated = nil
    }
  }
}

extension Bug: CustomStringConvertible {
  var description: String {
    String(format: "SR-\(id)")
  }
}
