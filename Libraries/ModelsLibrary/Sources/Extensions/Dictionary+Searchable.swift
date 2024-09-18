import Foundation

import CommonLibrary

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Searchable {
  /**
   Returns an object found in the `[String: Person]` structure.
   If no object is found, this method will return nil.

   - parameter username: login from user
   - returns: person object found
   */
  func get(username: String) -> Person? {
    var item: Person?

    for (_, value) in self {
      if value is Person, let person = value as? Person,
         person.username == username
      {
        item = person
      }
    }

    return item
  }
}
