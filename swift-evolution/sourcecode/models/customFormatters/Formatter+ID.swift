import Foundation

struct ProposalIDFormatter {
    static func format(unboxedValue: String) -> Int {
        let id: Int = unboxedValue.regex(Config.Common.Regex.proposalID)
        return id
    }
}

struct BugIDFormatter {
    static func format(unboxedValue: String) -> Int {
        let id: Int = unboxedValue.regex(Config.Common.Regex.bugID)
        return id
    }
}
