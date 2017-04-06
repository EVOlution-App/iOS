import UIKit
import Unbox

struct Person {
    var id: String?
    let name: String?
    let link: String?
    let username: String?

    // These properties will not come from server
    let github: GithubProfile? = nil
    var asAuthor: [Proposal]? = nil
    var asManager: [Proposal]? = nil
}

extension Person: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = unboxer.unbox(key: "name")
        self.link = unboxer.unbox(key: "link")
        self.username = unboxer.unbox(key: "link", formatter: GithubUserFormatter())
    }
}
