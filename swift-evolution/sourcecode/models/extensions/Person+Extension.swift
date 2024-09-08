// MARK: - Status State Extension

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Person {
  func filter(by value: String) -> [Person] {
    var filter: [Person] = []

    // Names
    let names = self.filter {
      guard let name = $0.name else {
        return false
      }
      return name.contains(value)
    }
    if names.isEmpty == false {
      filter.append(contentsOf: names)
    }

    // Users
    let users = self.filter {
      guard let name = $0.username else {
        return false
      }
      return name.contains(value)
    }
    if users.isEmpty == false {
      filter.append(contentsOf: users)
    }

    return filter
  }

  func get(username: String) -> Person? {
    guard let index = firstIndex(where: {
      guard let user = $0.username, username != "" else {
        return false
      }
      return user == username
    })
    else {
      return nil
    }

    return self[index]
  }

  func get(name: String) -> Person? {
    guard let index = firstIndex(where: {
      guard let user = $0.name, name != "" else {
        return false
      }
      return user == name
    })
    else {
      return nil
    }

    return self[index]
  }

  func get(identifier: String) -> Person? {
    guard let index = firstIndex(where: {
      guard let user = $0.identifier, identifier.isEmpty == false else {
        return false
      }
      return user == identifier
    })
    else {
      return nil
    }

    return self[index]
  }
}
