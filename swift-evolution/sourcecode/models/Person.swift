import UIKit
import Unbox

struct Person {
    let name: String?
    let link: String?
}

extension Person: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = unboxer.unbox(key: "name")
        self.link = unboxer.unbox(key: "link")
    }
}
