import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Searchable {
    /**
     Returns an object found on `[String: Person]` structure
     If any object could found, this method will return nil
     
    - parameter username: login from user
    - returns: person object found
     */
    func get(username: String) -> Person? {
        var item: Person?
        
        self.forEach { _, value in
            if value is Person, let person = value as? Person,
                person.username == username {
                item = person
            }
        }
        
        return item
    }
}
