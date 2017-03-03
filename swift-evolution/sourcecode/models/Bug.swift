import UIKit
import Unbox

struct Bug {
    let id: String?
    let status: String?
    let updated: Date?
    let title: String?
    let link: String?
    let radar: String?
    let assignee: String?
    let resolution: String?
}

extension Bug: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id         = unboxer.unbox(key: "id")
        self.status     = unboxer.unbox(key: "status")
        self.title      = unboxer.unbox(key: "title")
        self.link       = unboxer.unbox(key: "link")
        self.radar      = unboxer.unbox(key: "radar")
        self.resolution = unboxer.unbox(key: "resolution")
        self.assignee   = unboxer.unbox(key: "assignee")
        self.updated    = unboxer.unbox(key: "updated", formatter: Config.Date.Formatter.iso8601)
    }
}
