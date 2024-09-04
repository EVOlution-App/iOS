import UIKit

enum ImplementationType: String, Codable {
    case commit
    case pull
}

struct Implementation: Decodable {
    let type: ImplementationType
    let id: String
    let repository: String
    let account: String
}

extension Implementation: CustomStringConvertible {
    var description: String {
        var content = ""

        switch type {
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
        "\(account)/\(repository)/\(type.rawValue)/\(id)"
    }
}

extension Implementation: Equatable {
    public static func == (lhs: Implementation, rhs: Implementation) -> Bool {
        lhs.path == rhs.path
    }
}
