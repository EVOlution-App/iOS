import Foundation

extension Notifications {
    struct Device: Codable {
        let token: String
        let user: String
        let test: Bool?
        let os: String?
        let appVersion: String?
        let model: String?
        let language: String?
        var createdAt: Date? = nil
        var updatedAt: Date? = nil
    }
}
