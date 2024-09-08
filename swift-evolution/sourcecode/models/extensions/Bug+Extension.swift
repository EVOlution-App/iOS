// MARK: - Status State Extension

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Bug {
  func filter(by value: String) -> [Bug] {
    var filter: [Bug] = []

    // Identifier
    let identifiers = self.filter { String($0.identifier).lowercased() == value.lowercased() }
    if identifiers.isEmpty == false {
      filter.append(contentsOf: identifiers)
    }

    // Identifier with prefix
    let withPrefixes = self.filter { String($0.description).lowercased() == value.lowercased() }
    if withPrefixes.isEmpty == false {
      filter.append(contentsOf: withPrefixes)
    }

    // Status
    let statuses = self.filter {
      guard let status = $0.status else {
        return false
      }
      return status.lowercased() == value.lowercased()
    }

    if statuses.isEmpty == false {
      filter.append(contentsOf: statuses)
    }

    // Resolution
    let resolutions = self.filter {
      guard let resolution = $0.resolution else {
        return false
      }
      return resolution.lowercased() == value.lowercased()
    }

    if resolutions.isEmpty == false {
      filter.append(contentsOf: resolutions)
    }

    return filter
  }
}
