// MARK: - Status State Extension

public extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection,
  Iterator.Element == StatusState
{
  func filter(by value: String) -> [StatusState] {
    var filter: [StatusState] = []

    let states = self.filter { $0.name.contains(value) }
    if states.isEmpty == false {
      filter.append(contentsOf: states)
    }

    return filter
  }

  mutating func remove(_ status: StatusState) -> Bool {
    if let index = firstIndex(where: { $0 == status }) {
      remove(at: index)
      return true
    }

    return false
  }
}
