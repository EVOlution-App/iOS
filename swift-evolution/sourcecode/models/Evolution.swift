import Unbox
import Foundation

struct Evolution {
    let id: Int
    let title: String
    let status: Status
    let summary: String?
    let authors: [Person]?
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
        self.id = try unboxer.unbox(key: "id", formatter: ProposalIDFormatter())
        self.title = try unboxer.unbox(key: "title")
        self.warnings = unboxer.unbox(key: "warnings")
        self.link = unboxer.unbox(key: "link")
        self.reviewManager = unboxer.unbox(key: "reviewManager")
        self.sha = unboxer.unbox(key: "sha")
        self.bugs = unboxer.unbox(key: "trackingBugs")
    }
}

extension Evolution: CustomStringConvertible {
    var description: String {
        return String(format: "SE-%04i", self.id)
    }
}

extension Evolution: Comparable {
    public static func ==(lhs: Evolution, rhs: Evolution) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func <(lhs: Evolution, rhs: Evolution) -> Bool {
        return lhs.id < rhs.id
    }
    
    public static func <=(lhs: Evolution, rhs: Evolution) -> Bool {
        return lhs.id <= rhs.id
    }
    
    public static func >=(lhs: Evolution, rhs: Evolution) -> Bool {
        return lhs.id >= rhs.id
    }
    
    public static func >(lhs: Evolution, rhs: Evolution) -> Bool {
        return lhs.id > rhs.id
    }
}
