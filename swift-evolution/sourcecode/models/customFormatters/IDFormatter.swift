import Unbox

struct IDFormatter: UnboxFormatter {
    func format(unboxedValue: String) -> Int? {
        let id: Int = unboxedValue.regex(Config.Common.Regex.proposalID)
        
        return id

    }
}
