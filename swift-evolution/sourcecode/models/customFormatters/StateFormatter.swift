import Unbox

struct StateFormatter: UnboxFormatter {
    func format(unboxedValue: String) -> StatusState? {
        let state = State(unboxedValue)
        if let status = StatusState(rawValue: state) {
            return status
        }
        
        return nil
    }
}
