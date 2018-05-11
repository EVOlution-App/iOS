import Foundation

extension About {
    subscript(index: Int) -> ItemProtocol? {
        guard items.count > 0 else {
            return nil
        }
        
        let item = items[index]
        return item
    }
}
