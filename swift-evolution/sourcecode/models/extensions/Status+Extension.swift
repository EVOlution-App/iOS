// MARK: - Status State Extension

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Status {
    func filter(by value: String) -> [Status] {
        var filter: [Status] = []
        
        let versions = self.filter {
            guard let version = $0.version else {
                return false
            }
            return version.contains(value)
        }
        if versions.count > 0 {
            filter.append(contentsOf: versions)
        }
        
        let states = self.filter {
            let state = $0.state
            return state.rawValue.name.contains(value)
        }
        if states.count > 0 {
            filter.append(contentsOf: states)
        }
        
        return filter
    }
}
