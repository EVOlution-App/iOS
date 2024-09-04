import UIKit

// MARK: - GitHub Profile

struct GitHubProfile: Codable {
    let login: String
    let id: Int
    let avatar: String?
    let gravatar: String?
    let bio: String?

    enum Keys: String, CodingKey {
        case login
        case id
        case avatar_url
        case gravatar_url
        case bio
    }
}

extension GitHubProfile {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        login = try container.decode(String.self, forKey: .login)
        id = try container.decode(Int.self, forKey: .id)
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar_url)
        gravatar = try container.decodeIfPresent(String.self, forKey: .gravatar_url)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
    }
}
