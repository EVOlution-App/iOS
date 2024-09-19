import Foundation

extension Data {
  static func decode<T: Decodable>(from url: URL, to type: T.Type = T.self) throws -> T {
    let data = DataLoader.load(from: url)
    let object = try JSONDecoder().decode(type, from: data)
    
    return object
  }
}
