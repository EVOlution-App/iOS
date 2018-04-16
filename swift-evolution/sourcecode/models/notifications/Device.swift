import Foundation

extension Notifications {
    struct Device: Codable {
        let token: String
        let user: String
        let test: Bool?
        let os: String?
        let model: String?
        let language: String?
        let createdAt: Date? = nil
        let updatedAt: Date? = nil
    }
}
