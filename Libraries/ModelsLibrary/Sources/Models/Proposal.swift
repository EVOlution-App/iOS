import Foundation

// MARK: - Typealias

public typealias Proposals = [Proposal]

// MARK: -

public struct ProposalResponse: Decodable {
  public let proposals: Proposals
}

// MARK: -

public struct Proposal: Decodable {
  public let authors: People?
  public let bugs: Bugs?
  public let discussions: Discussions?
  public let featureFlag: FeatureFlag?
  public let identifier: Int
  public let implementations: Implementations?
  public let link: String?
  public let reviewManagers: People?
  public let sha: String?
  public let status: Status
  public let summary: String?
  public let title: String
  public let warnings: Warnings?

  enum CodingKeys: String, CodingKey {
    case authors
    case featureFlag = "upcomingFeatureFlag"
    case identifier = "id"
    case implementation
    case link
    case reviewManagers
    case sha
    case status
    case summary
    case title
    case trackingBugs
    case warnings
    case discussions
  }

  // MARK: - Initializer

  public init(identifier: Int, link: String) {
    self.identifier = identifier
    self.link = link
    title = ""
    status = Status(version: nil, state: .accepted, start: nil, end: nil)
    summary = nil
    authors = nil
    warnings = nil
    reviewManagers = nil
    sha = nil
    bugs = nil
    implementations = nil
    discussions = nil
    featureFlag = nil
  }

  // MARK: - Codable Initializer

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let value = try container.decode(String.self, forKey: .identifier)
    identifier = ProposalIdentifierFormatter.format(value)

    title = try container.decode(String.self, forKey: .title)
    status = try container.decode(Status.self, forKey: .status)
    summary = try container.decodeIfPresent(String.self, forKey: .summary)
    authors = try container.decodeIfPresent(People.self, forKey: .authors)
    warnings = try container.decodeIfPresent([Warning].self, forKey: .warnings)
    link = try container.decodeIfPresent(String.self, forKey: .link)
    reviewManagers = try container.decodeIfPresent(People.self, forKey: .reviewManagers)
    sha = try container.decodeIfPresent(String.self, forKey: .sha)
    bugs = try container.decodeIfPresent([Bug].self, forKey: .trackingBugs)
    implementations = try container.decodeIfPresent([Implementation].self, forKey: .implementation)
    featureFlag = try container.decodeIfPresent(FeatureFlag.self, forKey: .featureFlag)
    discussions = try container.decodeIfPresent([Discussion].self, forKey: .discussions)
  }

  // MARK: - Identifier

  public var identifierFormatted: String {
    String(format: "SE-%04i", identifier)
  }
}

// MARK: - Comparable

extension Proposal: Comparable {
  public static func == (lhs: Proposal, rhs: Proposal) -> Bool {
    lhs.identifier == rhs.identifier
  }

  public static func < (lhs: Proposal, rhs: Proposal) -> Bool {
    lhs.identifier < rhs.identifier
  }

  public static func <= (lhs: Proposal, rhs: Proposal) -> Bool {
    lhs.identifier <= rhs.identifier
  }

  public static func >= (lhs: Proposal, rhs: Proposal) -> Bool {
    lhs.identifier >= rhs.identifier
  }

  public static func > (lhs: Proposal, rhs: Proposal) -> Bool {
    lhs.identifier > rhs.identifier
  }
}

// MARK: - Hashable

extension Proposal: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}
