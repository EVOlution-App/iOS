import Foundation

struct Response: Codable {
    let statusCode: Int
    let reason: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case reason
    }
}
