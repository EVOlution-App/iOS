import UIKit

// MARK: - Enum Tag
enum Tag: String {
    case content = "content"
    case title = "title"
    case value = "value"
    case id = "id"
    
    func wrap(string: String) -> String {
        return "<\(self.rawValue)>\(string)</\(self.rawValue)>"
    }
}

// MARK: - String extension
extension String {
    /**
     Return a new line in text
     */
    static var newLine: String {
        return "\n"
    }
    
    /**
    Double space text
    */
    static var doubleSpace: String {
        return "  "
    }
    
    /**
     Wrap the text using tag
     ````
     print("Name:".tag(.title)) 
     // returns: "<title>Name:</title>
     
     ````
     - parameter tag: Tag enum to wrap text
     - returns: current text wrapped by tag
     */
    func tag(_ tag: Tag) -> String {
        return tag.wrap(string: self)
    }
    
    /**
     Return width from string based on height and font attributes
     
     - parameter height: height to base the string
     - parameter font: font attributes to check text
     - returns: width total based on attributes
     */
    func contraint(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSFontAttributeName: font],
                                            context: nil)
        return boundingBox.width
    }
    
}
