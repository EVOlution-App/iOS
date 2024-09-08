import UIKit

typealias People = [Person]

struct Person: Decodable {
  var identifier: String?
  let name: String?
  let link: String?
  let username: String?

  // These properties will not come from server
  var github: GitHubProfile?
  var asAuthor: [Proposal]?
  var asManager: [Proposal]?

  enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case name
    case link
  }
}

extension Person: Searchable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    link = try container.decodeIfPresent(String.self, forKey: .link)
    username = GitHubUserFormatter.format(unboxedValue: link)
  }
}
