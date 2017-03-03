import UIKit
import Unbox

struct Status {
    let version: String?
    let state: StatusState
    let start: Date?
    let end: Date?
}

extension Status: Unboxable {
    init(unboxer: Unboxer) throws {
        self.version = unboxer.unbox(key: "version")
        self.state = try unboxer.unbox(key: "state", formatter: StateFormatter())
        self.start = unboxer.unbox(key: "start", formatter: Config.Date.Formatter.yearMonthDay)
        self.end = unboxer.unbox(key: "end", formatter: Config.Date.Formatter.yearMonthDay)
    }
}
