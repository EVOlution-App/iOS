import Unbox

struct Warning {
    let message: String?
    let stage: String?
    let kind: String?
}

extension Warning: Unboxable {
    init(unboxer: Unboxer) throws {
        self.message = unboxer.unbox(key: "message")
        self.stage = unboxer.unbox(key: "stage")
        self.kind = unboxer.unbox(key: "kind")
    }
}
