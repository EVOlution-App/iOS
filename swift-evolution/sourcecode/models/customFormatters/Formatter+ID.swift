import Foundation

enum ProposalIdentifierFormatter {
  static func format(_ value: String) -> Int {
    value.regex(Config.Common.Regex.proposalIdentifier)
  }
}

enum BugIdentifierFormatter {
  static func format(_ value: String) -> Int {
    value.regex(Config.Common.Regex.bugIdentifier)
  }
}
