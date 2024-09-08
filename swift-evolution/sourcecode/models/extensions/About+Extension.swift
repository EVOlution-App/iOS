import Foundation

extension Section {
  subscript(index: Int) -> ItemProtocol? {
    guard items.isEmpty == false else {
      return nil
    }

    let item = items[index]
    return item
  }
}
