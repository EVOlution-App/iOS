import UIKit

public typealias AppWindowCoordinator = BaseCoordinator<UIWindow> & StartProtocol

public typealias SplitViewCoordinator = BaseCoordinator<UISplitViewController> & StartProtocol

public typealias NavigationCoordinator = BaseCoordinator<UINavigationController> & StartProtocol

public typealias ViewCoordinator = BaseCoordinator<UIViewController> & StartProtocol
