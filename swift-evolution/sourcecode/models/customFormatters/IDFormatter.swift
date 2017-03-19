import Unbox

struct ProposalIDFormatter: UnboxFormatter {
    func format(unboxedValue: String) -> Int? {
        let id: Int = unboxedValue.regex(Config.Common.Regex.proposalID)
        
        return id
    }
}

struct BugIDFormatter: UnboxFormatter {
    func format(unboxedValue: String) -> Int? {
        let id: Int = unboxedValue.regex(Config.Common.Regex.bugID)
        
        return id
    }
}
