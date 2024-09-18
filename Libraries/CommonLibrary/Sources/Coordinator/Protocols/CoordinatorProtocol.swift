public protocol CoordinatorProtocol: AnyObject {
  var children: [CoordinatorProtocol] { get }

  var parent: CoordinatorProtocol? { get set }

  func addChild(_ coordinator: CoordinatorProtocol)

  func removeChild(_ coordinator: CoordinatorProtocol)

  func removeAllChildren()
}

public extension Sequence<CoordinatorProtocol> {
  func filter<T: CoordinatorProtocol>(type _: T.Type) -> [T] {
    compactMap { $0 as? T }
  }

  @inlinable func forEach<T: CoordinatorProtocol>(type: T.Type, body: (T) throws -> Void) rethrows {
    try filter(type: type).forEach(body)
  }
}
