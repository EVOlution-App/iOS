import UIKit

open class BaseCoordinator<StartType>: CoordinatorProtocol {
  open weak var parent: CoordinatorProtocol?

  open private(set) var children: [CoordinatorProtocol] = []

  public init(children: [CoordinatorProtocol] = []) {
    children.forEach { addChild($0) }
  }

  // MARK: - Coordinator Protocol

  open func addChild(_ coordinator: CoordinatorProtocol) {
    coordinator.parent = self

    for child in children where child === coordinator {
      return
    }

    children.append(coordinator)
  }

  open func removeChild(_ coordinator: CoordinatorProtocol) {
    if let index = children.firstIndex(where: { $0 === coordinator }) {
      let child = children.remove(at: index)
      child.parent = nil
    }
  }

  open func removeAllChildren() {
    children.forEach { removeChild($0) }
  }
}
