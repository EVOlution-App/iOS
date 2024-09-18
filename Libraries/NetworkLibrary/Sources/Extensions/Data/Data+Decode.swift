import Foundation

extension Data {
  public func decode<T: Decodable>(to type: T.Type = T.self) throws -> T {
    let decoder = JSONDecoder()
    let object = try decoder.decode(type, from: self)
    
    return object
  }
}
