import Foundation

extension Sequence where Self: RandomAccessCollection, Iterator.Element == ItemProtocol {
    /// Used to show a proper description about the amount of third libraries used by the project
    var text: String {
        var value = ""
        if count == 1, let first {
            value = first.text
        }
        else if count >= 2, let first, let last {
            if count == 2 {
                value = "\(first.text) and \(last.text)"
            }
            else if count > 2 {
                value = "\(first.text), \(last.text) and \(count - 2) more..."
            }
        }

        return value
    }
}
