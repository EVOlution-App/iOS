import UIKit

import ModelsLibrary

// MARK: - SegueRepresentable Extension

extension SegueRepresentable where RawValue == String {
  func performSegue(in viewController: UIViewController?,
                    split: Bool = false,
                    formSheet: Bool = false)
  {
    performSegue(in: viewController, with: nil, split: split, formSheet: formSheet)
  }

  func performSegue(in viewController: UIViewController?,
                    with object: Any? = nil,
                    split: Bool = false,
                    formSheet: Bool = false)
  {
    let defaultSegue: () -> Void = {
      viewController?.performSegue(withIdentifier: self.rawValue, sender: object)
    }

    if UIDevice.current.userInterfaceIdiom == .pad {
      if split {
        splitHelper(in: viewController, with: object)
      }
      else if formSheet {
        profileHelper(in: viewController, with: object)
      }
      else {
        defaultSegue()
      }
    }
    else {
      defaultSegue()
    }
  }

  private func detailNavigationController() -> UINavigationController? {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    guard let navigationController = storyboard
      .instantiateViewController(withIdentifier: "DetailsNavigationStoryboardID") as? UINavigationController
    else {
      return nil
    }

    return navigationController
  }

  private func splitHelper(in viewController: UIViewController?, with object: Any? = nil) {
    guard let navigationController = detailNavigationController() else {
      return
    }

    guard let controller = navigationController.topViewController as? ProposalDetailViewController else {
      return
    }

    controller.proposal = object as? Proposal
    viewController?.showDetailViewController(navigationController, sender: object)
  }

  private func profileHelper(in viewController: UIViewController?, with object: Any? = nil) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    guard let controller = storyboard
      .instantiateViewController(withIdentifier: "ProfileStoryboardID") as? ProfileViewController
    else {
      return
    }

    controller.modalPresentationStyle = .formSheet
    controller.profile = object as? Person

    viewController?.present(controller, animated: true)
  }
}
