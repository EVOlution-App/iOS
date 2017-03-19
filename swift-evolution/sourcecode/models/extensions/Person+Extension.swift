// MARK: - Status State Extension

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Person {
    func filter(by value: String) -> [Person] {
        var filter: [Person] = []
        
        // Names
        let names = self.filter {
            guard let name = $0.name else { return false }
            return name.contains(value)
        }
        if names.count > 0 {
            filter.append(contentsOf: names)
        }
        
        // Users
        let users = self.filter {
            guard let name = $0.username else { return false }
            return name.contains(value)
        }
        if users.count > 0 {
            filter.append(contentsOf: users)
        }
        
        return filter
    }
}
