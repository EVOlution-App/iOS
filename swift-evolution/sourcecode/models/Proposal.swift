import Foundation

struct ProposalResponse: Decodable {
    let proposals: [Proposal]
}

struct Proposal: Decodable {
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
    let implementations: [Implementation]?

    enum Keys: String, CodingKey {
        case status
        case summary
        case authors
        case id
        case title
        case warnings
        case link
        case reviewManager
        case sha
        case trackingBugs
        case implementation
    }

    init(id: Int, link: String) {
        self.id = id
        self.link = link
        title = ""
        status = Status(version: nil, state: .accepted, start: nil, end: nil)
        summary = nil
        authors = nil
        warnings = nil
        reviewManager = nil
        sha = nil
        bugs = nil
        implementations = nil
    }
}

extension Proposal {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        let idString = try container.decode(String.self, forKey: .id)
        id = ProposalIDFormatter.format(unboxedValue: idString)

        title = try container.decode(String.self, forKey: .title)
        status = try container.decode(Status.self, forKey: .status)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        authors = try container.decodeIfPresent([Person].self, forKey: .authors)
        warnings = try container.decodeIfPresent([Warning].self, forKey: .warnings)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        reviewManager = try container.decodeIfPresent(Person.self, forKey: .reviewManager)
        sha = try container.decodeIfPresent(String.self, forKey: .sha)
        bugs = try container.decodeIfPresent([Bug].self, forKey: .trackingBugs)
        implementations = try container.decodeIfPresent([Implementation].self, forKey: .implementation)
    }
}

extension Proposal: CustomStringConvertible {
    var description: String {
        String(format: "SE-%04i", id)
    }
}

extension Proposal: Comparable {
    public static func == (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id == rhs.id
    }

    public static func < (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id < rhs.id
    }

    public static func <= (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id <= rhs.id
    }

    public static func >= (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id >= rhs.id
    }

    public static func > (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id > rhs.id
    }
}
