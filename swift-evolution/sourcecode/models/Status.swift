import Unbox

struct Status {
    let version: String?
    let state: StatusState
}

extension Status: Unboxable {
    init(unboxer: Unboxer) throws {
        self.version = unboxer.unbox(key: "version")
        self.state = try unboxer.unbox(key: "state", formatter: StateFormatter())
    }
}
