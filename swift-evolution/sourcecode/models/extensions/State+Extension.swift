// MARK: - Status State Extension

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == StatusState {
    func filter(by value: String) -> [StatusState] {
        var filter: [StatusState] = []
        
        let states = self.filter { $0.rawValue.name.contains(value) }
        if states.count > 0 {
            filter.append(contentsOf: states)
        }
        
        return filter
    }
    
    mutating func remove(_ status: StatusState) -> Bool {
        if let index = self.index(where: { $0 == status }) {
            self.remove(at: index)
            return true
        }
        
        return false
    }
}
