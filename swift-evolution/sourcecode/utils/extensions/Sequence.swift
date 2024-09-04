// MARK: - String Extension

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == String {
    mutating func remove(string: String) -> Bool {
        if let index = firstIndex(where: { $0 == string }) {
            remove(at: index)
            return true
        }

        return false
    }
}
