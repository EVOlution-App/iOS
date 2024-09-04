import Foundation

extension Section {
    subscript(index: Int) -> ItemProtocol? {
        guard !items.isEmpty else {
            return nil
        }

        let item = items[index]
        return item
    }
}
