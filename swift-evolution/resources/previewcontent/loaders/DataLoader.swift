import Foundation

final class DataLoader {
  private init() {}
  
  static func load(from url: URL) -> Data {
    guard let data = try? Data(contentsOf: url) else {
      fatalError("Unable to read \(url.absoluteString)")
    }
    
    return data
  }
}
