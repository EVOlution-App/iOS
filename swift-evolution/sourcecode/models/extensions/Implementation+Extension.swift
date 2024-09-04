// MARK: - Implementation Extension

import Foundation

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection,
    Iterator.Element == Implementation
{
    func get(by path: String) -> Implementation? {
        guard let index = firstIndex(where: { $0.path == path }) else {
            return nil
        }

        return self[index]
    }

    func index(of implementation: Implementation) -> Int? {
        firstIndex(where: { $0 == implementation }) as? Int
    }
}
