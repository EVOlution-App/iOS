import Foundation
import KeychainAccess

struct User: Codable {
    let id: String
    let tags: [Notifications.Tag]?
    let createdAt: Date?
    let updatedAt: Date?
    
    
    enum Keys: String, CodingKey {
        case id = "ckID"
        case tags
        case createdAt
        case updatedAt
    }
    
    init(id: String, tags: [Notifications.Tag]? = nil) {
        self.id = id
        self.tags = tags
        self.createdAt = nil
        self.updatedAt = nil
    }
}

extension User {
    static var current: User? {
        let bundleID = Environment.bundleID ?? "io.swift-evolution.app"
        let keychain = Keychain(service: bundleID).synchronizable(true)
        
        guard let token = try? keychain.getString("currentUser"), let id = token else {
            return nil
        }
        
        return User(id: id)
    }
}
