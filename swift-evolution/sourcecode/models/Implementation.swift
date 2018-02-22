import UIKit

enum TypeOfImplementation: String {
    case commit
    case pull
}

extension TypeOfImplementation: RawRepresentable {
    public init(rawValue: RawValue) {
        switch rawValue {
        case "commit":
            self = .commit
        
        case "pull":
            self = .pull
            
        default:
            self = .pull
        }
    }
}

struct Implementation: Decodable {
    let type: TypeOfImplementation
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
        
        let type = try container.decode(String.self, forKey: .type)
        self.type = TypeOfImplementation(rawValue: type)
        
        id          = try container.decode(String.self, forKey: .id)
        repository  = try container.decode(String.self, forKey: .repository)
        account     = try container.decode(String.self, forKey: .account)
    }
}

extension Implementation: CustomStringConvertible {
    var description: String {
        var content: String = ""
        
        switch self.type {
        case .pull:
            content = "\(repository)#\(id)"
            
        case .commit:
            let index = id.index(id.startIndex, offsetBy: 7)
            let hash = id.prefix(upTo: index)
            
            content = "\(repository)@\(hash)"
            
        }
        return content
    }
    
    var path: String {
        return "\(account)/\(repository)/\(type.rawValue)/\(id)"
    }
}

extension Implementation: Equatable {
    public static func == (lhs: Implementation, rhs: Implementation) -> Bool {
        return lhs.path == rhs.path
    }
}
