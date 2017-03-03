import Unbox

struct Evolution {
    let status: Status
    let summary: String?
    let authors: [Person]?
    let id: String
    let title: String
    let warnings: [Warning]?
    let link: String?
    let reviewManager: Person?
    let sha: String?
    let bugs: [Bug]?
}

extension Evolution: Unboxable {
    init(unboxer: Unboxer) throws {
        self.status = try unboxer.unbox(key: "status")
        self.summary = unboxer.unbox(key: "summary")
        self.authors = unboxer.unbox(key: "authors")
        self.id = try unboxer.unbox(key: "id")
        self.title = try unboxer.unbox(key: "title")
        self.warnings = unboxer.unbox(key: "warnings")
        self.link = unboxer.unbox(key: "link")
        self.reviewManager = unboxer.unbox(key: "reviewManager")
        self.sha = unboxer.unbox(key: "sha")
        self.bugs = unboxer.unbox(key: "trackingBugs")
    }
}
