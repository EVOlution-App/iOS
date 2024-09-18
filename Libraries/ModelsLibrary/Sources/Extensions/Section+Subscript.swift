import Foundation

extension Section {
  public subscript(index: Int) -> ItemProtocol? {
    guard items.isEmpty == false else {
      return nil
    }

    return items[index]
  }
}
