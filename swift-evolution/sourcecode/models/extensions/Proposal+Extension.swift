// MARK: - Proposals Filters

public enum Sorting {
    case ascending
    case descending
}

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Proposal {
    func filter(author: Person) -> [Proposal] {
        var filter: [Proposal] = []
        guard let name = author.name else {
            return []
        }

        let authors = self.filter {
            guard let authors = $0.authors else { return false }
            return authors.filter(by: name).count > 0
        }
        if authors.count > 0 {
            filter.append(contentsOf: authors)
        }
        
        return filter
    }
    
    func filter(manager: Person) -> [Proposal] {
        var filter: [Proposal] = []
        
        guard let managerName = manager.name else {
            return []
        }
        
        let reviewManagers = self.filter {
            guard let manager = $0.reviewManager,
                let name = manager.name,
                name == managerName
                else {
                    return false
            }
            return true
        }
        if reviewManagers.count > 0 {
            filter.append(contentsOf: reviewManagers)
        }
        
        return filter
    }
    
    func filter(status: StatusState) -> [Proposal] {
        return self.filter { $0.status.state == status }
    }
    
    func filter(language version: Version) -> [Proposal] {
        return self.filter { $0.status.version == version}
    }
    
    func filter(by value: String) -> [Proposal] {
        var filter: [Proposal] = []
        
        // ID
        let ids = self.filter { String($0.id) == value }
        if ids.count > 0 {
            filter.append(contentsOf: ids)
        }
        
        // ID with prefix
        let withPrefixes = self.filter { String($0.description).lowercased() == value.lowercased() }
        if withPrefixes.count > 0 {
            filter.append(contentsOf: withPrefixes)
        }
        
        // Title
        let titles = self.filter { $0.title.contains(value) }
        if titles.count > 0 {
            filter.append(contentsOf: titles)
        }
        
        // Status
        let statuses = self.filter { $0.status.state.rawValue.name.contains(value) }
        if statuses.count > 0 {
            filter.append(contentsOf: statuses)
        }
        
        // Summary
        let summaries = self.filter {
            guard let summary = $0.summary else { return false }
            return summary.contains(value)
        }
        if summaries.count > 0 {
            filter.append(contentsOf: summaries)
        }
        
        // Author
        let authors = self.filter {
            guard let authors = $0.authors else { return false }
            return authors.filter(by: value).count > 0
        }
        if authors.count > 0 {
            filter.append(contentsOf: authors)
        }
        
        // Review Manager
        let reviews = self.filter {
            guard let manager = $0.reviewManager,
                let name = manager.name,
                let username = manager.username
                else {
                    return false
            }
            return (name.contains(value) || username == value)
        }
        if reviews.count > 0 {
            filter.append(contentsOf: reviews)
        }
        
        // Bug
        let bugs = self.filter {
            guard let bugs = $0.bugs else { return false }
            return bugs.filter(by: value).count > 0
        }
        if bugs.count > 0 {
            filter.append(contentsOf: bugs)
        }
        
        return filter
    }
    
    func filter(by languages: [Version]) -> [Proposal] {
        var filter: [Proposal] = []
        
        languages.forEach { language in
            let list = self.filter(language: language)
            filter.append(contentsOf: list)
        }
        
        return filter
    }
    
    func filter(by statuses: [StatusState], exceptions: [StatusState] = []) -> [Proposal] {
        var filter: [Proposal] = []
        
        statuses.forEach { state in
            guard exceptions.contains(state) == false else {
                return
            }
            
            let list = self.filter(status: state).sort(.descending)
            filter.append(contentsOf: list)
        }
        
        return filter
    }
    
    func index(of proposal: Proposal) -> Int? {
        return self.index(where: { $0 == proposal }) as? Int
    }
    
    func sort(_ direction: Sorting) -> [Proposal] {
        return self.sorted(by: direction == .ascending ? { $0 < $1 } : { $0 > $1 })
    }
    
    /**
     Remove duplicated items from current list
     */
    func distinct() -> [Proposal] {
        var result: [Proposal] = []
        
        for value in self {
            if result.index(of: value) == nil {
                result.append(value)
            }
        }
        
        return result
    }
}
