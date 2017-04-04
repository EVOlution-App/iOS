import UIKit
import Unbox

// MARK: - Github Profile
struct GithubProfile {
    let login: String
    let id: Int
    let avatar: String?
    let gravatar: String?
    let bio: String?
}

extension GithubProfile: Unboxable {
    init(unboxer: Unboxer) throws {
        self.login      = try unboxer.unbox(key: "login")
        self.id         = try unboxer.unbox(key: "id")
        self.avatar     = unboxer.unbox(key: "avatar_url")
        self.gravatar   = unboxer.unbox(key: "gravatar_id")
        self.bio        = unboxer.unbox(key: "bio")
    }
}
