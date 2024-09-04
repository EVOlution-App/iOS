import UIKit

typealias People = [Person]

struct Person: Decodable {
    var id: String?
    let name: String?
    let link: String?
    let username: String?

    // These properties will not come from server
    var github: GitHubProfile?
    var asAuthor: [Proposal]?
    var asManager: [Proposal]?

    enum Keys: String, CodingKey {
        case id
        case name
        case link
    }
}

extension Person: Searchable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        username = GitHubUserFormatter.format(unboxedValue: link)
    }
}
