import UIKit

import ModelsLibrary

// MARK: - FilterGenericView Delegate

extension ListProposalsViewController: FilterGenericViewDelegate {
  func filterGenericView(_ view: FilterListGenericView, didSelectFilter type: FilterListGenericType, at indexPath: IndexPath) {
    switch type {
    case .status:
      if filterHeaderView.statusSource[indexPath.item] == .implemented {
        filterHeaderView.filterLevel = .version
        layoutFilterHeaderView()

        languages = []
      }

      if let item: StatusState = view.dataSource[indexPath.item] as? StatusState {
        status.append(item)
      }

      updateTableView()

    case .version:
      if let version = view.dataSource[indexPath.item] as? String {
        languages.append(version)
      }

      updateTableView()

    default:
      break
    }
    filterHeaderView.updateFilterButton(status: status)
  }

  func filterGenericView(_ view: FilterListGenericView, didDeselectFilter type: FilterListGenericType, at indexPath: IndexPath) {
    let item = view.dataSource[indexPath.item]

    switch type {
    case .status:
      if let indexPaths = view.indexPathsForSelectedItems,
         indexPaths.compactMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == .implemented })
         .isEmpty
      {
        filterHeaderView.filterLevel = .status
        layoutFilterHeaderView()
      }

      if let status = item as? StatusState, self.status.remove(status) {
        updateTableView()
      }

    case .version:
      if languages.remove(string: item.description) {
        updateTableView()
      }

    default:
      break
    }
    filterHeaderView.updateFilterButton(status: status)
  }
}
