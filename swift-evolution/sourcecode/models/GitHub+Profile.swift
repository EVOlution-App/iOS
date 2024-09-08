import UIKit

// MARK: - GitHub Profile

struct GitHubProfile: Codable {
  let login: String
  let identifier: Int
  let avatar: String?
  let gravatar: String?
  let bio: String?

  enum CodingKeys: String, CodingKey {
    case login
    case identifier = "id"
    case avatar = "avatar_url"
    case gravatar = "gravatar_url"
    case bio
  }
}

extension GitHubProfile {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    login = try container.decode(String.self, forKey: .login)
    identifier = try container.decode(Int.self, forKey: .identifier)
    avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
    gravatar = try container.decodeIfPresent(String.self, forKey: .gravatar)
    bio = try container.decodeIfPresent(String.self, forKey: .bio)
  }
}
