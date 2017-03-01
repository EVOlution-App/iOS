import Unbox

struct Evolution {
    let status: Status?
    let summary: String?
    let authors: [Person]?
    let id: String?
    let title: String?
    let warnings: [Warning]?
    let link: String?
    let reviewManager: [Person]?
    let sha: String?
    let trackingBugs: [Bug]?
}

extension Evolution: Unboxable {
    init(unboxer: Unboxer) throws {
        self.status = unboxer.unbox(key: "status")
        self.summary = unboxer.unbox(key: "summary")
        self.authors = unboxer.unbox(key: "authors")
        self.id = unboxer.unbox(key: "id")
        self.title = unboxer.unbox(key: "title")
        self.warnings = unboxer.unbox(key: "warnings")
        self.link = unboxer.unbox(key: "link")
        self.reviewManager = unboxer.unbox(key: "reviewManager")
        self.sha = unboxer.unbox(key: "sha")
        self.trackingBugs = unboxer.unbox(key: "trackingBugs")
    }
}
