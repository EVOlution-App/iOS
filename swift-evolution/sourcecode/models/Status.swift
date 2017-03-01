import UIKit
import Unbox

struct Status {
    let version: String?
    let state: String?
}

extension Status: Unboxable {
    init(unboxer: Unboxer) throws {
        self.version = unboxer.unbox(key: "version")
        self.state = unboxer.unbox(key: "state")
    }
}
