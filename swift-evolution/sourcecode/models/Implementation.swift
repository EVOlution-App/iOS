import UIKit

struct Implementation: Decodable {
    let type: String
    let id: String
    let repository: String
    let account: String
    
    enum Keys: String, CodingKey {
        case type
        case id
        case repository
        case account
    }
}

extension Implementation {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        type        = try container.decode(String.self, forKey: .type)
        id          = try container.decode(String.self, forKey: .id)
        repository  = try container.decode(String.self, forKey: .repository)
        account     = try container.decode(String.self, forKey: .account)
        
    }
    
}

