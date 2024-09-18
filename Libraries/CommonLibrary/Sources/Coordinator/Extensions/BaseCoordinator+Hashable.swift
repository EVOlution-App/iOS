extension BaseCoordinator: Hashable {
  public static func == (lhs: BaseCoordinator<StartType>, rhs: BaseCoordinator<StartType>) -> Bool {
    lhs === rhs
  }

  public func hash(into hasher: inout Hasher) {
    ObjectIdentifier(self).hash(into: &hasher)
  }
}
