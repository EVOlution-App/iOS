// MARK: - Status State Extension

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Bug {
  func filter(by value: String) -> [Bug] {
    var filter: [Bug] = []

    // ID
    let ids = self.filter { String($0.id).lowercased() == value.lowercased() }
    if !ids.isEmpty {
      filter.append(contentsOf: ids)
    }

    // ID with prefix
    let withPrefixes = self.filter { String($0.description).lowercased() == value.lowercased() }
    if !withPrefixes.isEmpty {
      filter.append(contentsOf: withPrefixes)
    }

    // Status
    let statuses = self.filter {
      guard let status = $0.status else {
        return false
      }
      return status.lowercased() == value.lowercased()
    }
    if !statuses.isEmpty {
      filter.append(contentsOf: statuses)
    }

    // Resolution
    let resolutions = self.filter {
      guard let resolution = $0.resolution else {
        return false
      }
      return resolution.lowercased() == value.lowercased()
    }
    if !resolutions.isEmpty {
      filter.append(contentsOf: resolutions)
    }

    return filter
  }
}
