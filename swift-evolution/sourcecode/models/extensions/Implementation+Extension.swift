// MARK: - Implementation Extension

import Foundation

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Implementation {
    func get(by path: String) -> Implementation? {
        guard let index = self.index(where: { $0.path == path }) else {
            return nil
        }
        
        return self[index]
    }
    
    func index(of implementation: Implementation) -> Int? {
        return self.index(where: { $0 == implementation }) as? Int
    }
}
