import Foundation

struct Track: Codable {
    let appID: String
    let opened: Bool
    
    enum Keys: String, CodingKey {
        case appID = "app_id"
        case opened
    }
}
