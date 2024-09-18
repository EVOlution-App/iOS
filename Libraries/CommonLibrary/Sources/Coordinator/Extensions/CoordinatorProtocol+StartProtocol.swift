import UIKit

public typealias CoordinatorStartProtocol = CoordinatorProtocol & StartProtocol

// MARK: - StartProtocol -> UIViewController

extension StartProtocol where Self: CoordinatorProtocol, StartType: UIViewController {
  public func start<T: CoordinatorStartProtocol>(
    presenting coordinator: T,
    animated: Bool
  ) where T.StartType: RootViewControllerProtocol {
    addChild(coordinator)

    let startViewController = coordinator.start()

    start().safePresent(startViewController, animated: animated)
  }

  public func start<T: CoordinatorStartProtocol>(
    presenting coordinator: T, in navigationController: UINavigationController, animated: Bool
  ) where T.StartType: RootViewControllerProtocol {
    addChild(coordinator)

    let startViewController = coordinator.start()
    navigationController.pushViewController(startViewController, animated: false)

    start()
      .safePresent(navigationController, animated: animated)
  }
}

// MARK: - StartProtocol -> UIWindow

extension StartProtocol where Self: CoordinatorProtocol, StartType: RootViewControllerProtocol {
  public func start<T: CoordinatorStartProtocol>(
    pushing coordinator: T, in navigationController: UINavigationController, animated: Bool
  ) where T.StartType: UIViewController {
    addChild(coordinator)

    let startViewController = coordinator.start()

    navigationController.pushViewController(startViewController, animated: animated)
  }
}

extension StartProtocol where Self: CoordinatorProtocol, StartType: UINavigationController {
  public func start<T: CoordinatorStartProtocol>(pushing coordinator: T, animated: Bool)
  where T.StartType: UIViewController {
    addChild(coordinator)

    let startViewController = coordinator.start()

    start().pushViewController(startViewController, animated: animated)
  }
}

// MARK: - StartProtocol -> UIWindow

extension StartProtocol where Self: CoordinatorProtocol, StartType: UIWindow {
  public func start<T: CoordinatorStartProtocol>(root coordinator: T)
  where T.StartType: RootViewControllerProtocol {
    removeAllChildren()
    addChild(coordinator)

    let startRootViewController = coordinator.start()
    start().rootViewController = startRootViewController

    start().makeKeyAndVisible()
  }

  public func start<T: CoordinatorStartProtocol>(presenting coordinator: T, animated: Bool)
  where T.StartType: RootViewControllerProtocol {
    addChild(coordinator)

    let startRootViewController = coordinator.start()
    start().rootViewController?.safePresent(startRootViewController, animated: animated)

    start().makeKeyAndVisible()
  }
}
