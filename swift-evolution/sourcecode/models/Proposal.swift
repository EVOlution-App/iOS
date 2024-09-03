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
        self.id                 = id
        self.link               = link
        self.title              = ""
        self.status             = Status(version: nil, state: .accepted, start: nil, end: nil)
        self.summary            = nil
        self.authors            = nil
        self.warnings           = nil
        self.reviewManager      = nil
        self.sha                = nil
        self.bugs               = nil
        self.implementations    = nil
    }
    
}

extension Proposal {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let idString = try container.decode(String.self, forKey: .id)
        self.id = ProposalIDFormatter.format(unboxedValue: idString)
        
        self.title              = try container.decode(String.self, forKey: .title)
        self.status             = try container.decode(Status.self, forKey: .status)
        self.summary            = try container.decodeIfPresent(String.self, forKey: .summary)
        self.authors            = try container.decodeIfPresent([Person].self, forKey: .authors)
        self.warnings           = try container.decodeIfPresent([Warning].self, forKey: .warnings)
        self.link               = try container.decodeIfPresent(String.self, forKey: .link)
        self.reviewManager      = try container.decodeIfPresent(Person.self, forKey: .reviewManager)
        self.sha                = try container.decodeIfPresent(String.self, forKey: .sha)
        self.bugs               = try container.decodeIfPresent([Bug].self, forKey: .trackingBugs)
        self.implementations    = try container.decodeIfPresent([Implementation].self, forKey: .implementation)
    }
    
}

extension Proposal: CustomStringConvertible {
    var description: String {
        return String(format: "SE-%04i", self.id)
    }
}

extension Proposal: Comparable {
    public static func == (lhs: Proposal, rhs: Proposal) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func < (lhs: Proposal, rhs: Proposal) -> Bool {
        return lhs.id < rhs.id
    }
    
    public static func <= (lhs: Proposal, rhs: Proposal) -> Bool {
        return lhs.id <= rhs.id
    }
    
    public static func >= (lhs: Proposal, rhs: Proposal) -> Bool {
        return lhs.id >= rhs.id
    }
    
    public static func > (lhs: Proposal, rhs: Proposal) -> Bool {
        return lhs.id > rhs.id
    }
}
