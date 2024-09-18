import Foundation

enum ProposalIdentifierFormatter {
  static func format(_ value: String) -> Int {
    value.regex("SE-([0-9]+)")
  }
}

enum BugIdentifierFormatter {
  static func format(_ value: String) -> Int {
    value.regex("SR-([0-9]+)")
  }
}

private extension String {
  /**
   Find the first Int based on Regular Expression
   
   - parameter pattern: regular expression to find an Int
   - returns: first Int found
   */
  func regex(_ pattern: String) -> Int {
    let results: [Int] = regex(pattern)
    guard let item = results.first, results.isEmpty == false else {
      return NSNotFound
    }
    
    return item
  }
  
  /**
   Find a list of Int based on Regular Expression
   
   - parameter pattern: regular expression to find a list of Int
   - returns: list of Int found
   */
  func regex(_ pattern: String) -> [Int] {
    guard let expression = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
      return []
    }
    
    let results = expression.matches(
      in: self,
      options: .reportCompletion,
      range: NSRange(location: 0, length: count)
    )
    let contents: [Int] = results.compactMap { _ in
      Int(String(unicodeScalars.filter(CharacterSet.decimalDigits.contains)))
    }
    
    return contents
  }
}
