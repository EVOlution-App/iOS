// MARK: - Proposals Filters

public enum Sorting {
    case ascending
    case descending
}

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Evolution {
    func filter(status: StatusState) -> [Evolution] {
        return self.filter { $0.status.state == status }
    }
    
    func filter(language version: Version) -> [Evolution] {
        return self.filter { $0.status.version == version}
    }
    
    func filter(query: String) -> [Evolution] {
        return self.filter { $0.title.contains(query) }
    }
    
    func filter(by languages: [Version]) -> [Evolution] {
        var filter: [Evolution] = []
        
        languages.forEach { language in
            let list = self.filter(language: language)
            filter.append(contentsOf: list)
        }

        return filter
    }
    
    func filter(by statuses: [StatusState], exceptions: [StatusState] = []) -> [Evolution] {
        var filter: [Evolution] = []
        
        statuses.forEach { state in
            guard exceptions.contains(state) == false else {
                return
            }
            
            let list = self.filter(status: state).sort(.descending)
            filter.append(contentsOf: list)
        }
        
        return filter
    }
    
    func index(of proposal: Evolution) -> Int? {
        return self.index(where: { $0 == proposal }) as? Int
    }

    func sort(_ direction: Sorting) -> [Evolution] {
        return self.sorted(by: direction == .ascending ? { $0 < $1 } : { $0 > $1 })
    }
    
    mutating func removeDuplicates() -> [Evolution] {
        var result: [Evolution] = []
    
        for value in self {
            if result.index(of: value) == nil {
                result.append(value)
            }
        }
        
        return result
    }
}

// MARK: - Extension Sequence Status Filter

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == StatusState {
    mutating func remove(_ status: StatusState) -> Bool {
        if let index = self.index(where: { $0 == status }) {
            self.remove(at: index)
            return true
        }
        
        return false
    }
}

// MARK: - Extension Sequence String
extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == String {
    mutating func remove(string: String) -> Bool {
        if let index = self.index(where: { $0 == string }) {
            self.remove(at: index)
            return true
        }
        
        return false
    }
}
