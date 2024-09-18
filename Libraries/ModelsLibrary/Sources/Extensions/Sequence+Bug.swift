// MARK: - Status State Extension

public extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Bug {
  func filter(by value: String) -> [Bug] {
    var filter: [Bug] = []

    // Identifier
    let identifiers = self.filter { String($0.identifier).lowercased() == value.lowercased() }
    if identifiers.isEmpty == false {
      filter.append(contentsOf: identifiers)
    }

    // Identifier with prefix
    let withPrefixes = self.filter { String($0.identifier).lowercased() == value.lowercased() }
    if withPrefixes.isEmpty == false {
      filter.append(contentsOf: withPrefixes)
    }

    return filter
  }
}
