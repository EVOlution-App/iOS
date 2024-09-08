import Foundation

extension Notifications {
  struct Tag: Codable {
    let id: String // swiftlint:disable:this no_abbreviation_id
    let name: String
    let identifier: String
    let subscribed: Bool?

    enum CodingKeys: String, CodingKey {
      case id = "_id" // swiftlint:disable:this no_abbreviation_id
      case name
      case identifier
      case subscribed
    }
  }
}
