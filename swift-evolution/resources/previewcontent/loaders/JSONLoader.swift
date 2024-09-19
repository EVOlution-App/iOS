import Foundation

typealias JSONDictionary = [String: Any]
typealias JSONArray = [[String: Any]]

final class JSONLoader: Sendable {
  
  static let shared = JSONLoader()
  
  private init(){}
  
  func load<T>(_ filename: String, as type: T.Type = T.self, in bundle: Bundle = Bundle.main) throws -> T {
    let fileURL = FileLoader.url(for: filename, type: .json, in: bundle)
    let data = DataLoader.load(from: fileURL)
    
    return try serializeJSON(from: data)
  }
  
  private func serializeJSON<T>(from data: Data) throws -> T {
    do {
      let content = try JSONSerialization.jsonObject(with: data)
      
      guard let json = content as? T else {
        throw LoadError.invalidType("[JSONLoader] Invalid type: \(String(describing: T.self))")
      }
      
      return json
    }
    catch {
      fatalError(error.localizedDescription)
    }
  }
}
