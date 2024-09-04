import Foundation

extension Notifications {
    struct Tag: Codable {
        let id: String
        let name: String
        let identifier: String
        let subscribed: Bool?

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
            case identifier
            case subscribed
        }
    }
}
