import Foundation

enum FileLoader {
  enum Extension: String {
    case json
    case html
    case text = "txt"
    case xml
    case markdown = "md"
  }
  
  static func url(for file: String, type extension: Extension, in bundle: Bundle = Bundle.main) -> URL {
    guard let fileURL = bundle.url(forResource: file, withExtension: `extension`.rawValue) else {
      fatalError("Couldn't find \(file).\(`extension`) in current bundle")
    }
    
    return fileURL
  }
}
