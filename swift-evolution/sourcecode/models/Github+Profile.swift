import UIKit

// MARK: - Github Profile
struct GithubProfile: Codable {
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

extension GithubProfile {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.login = try container.decode(String.self, forKey: .login)
        self.id = try container.decode(Int.self, forKey: .id)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar_url)
        self.gravatar = try container.decodeIfPresent(String.self, forKey: .gravatar_url)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
    }
    
}
