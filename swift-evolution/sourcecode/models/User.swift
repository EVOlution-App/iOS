import Foundation
import KeychainAccess

struct User: Codable {
    let id: String
    
    enum Keys: String, CodingKey {
        case id = "userID"
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
