import Foundation

struct Device: Codable {
    let identifier: String
    let vendor: String
    let test: Bool?
    let subscribed: Bool?
    let os: String?
    let model: String?
    let tags: [[String: String]]?
    let language: String?
    let createdAt: Date? = nil
    let updatedAt: Date? = nil
}
