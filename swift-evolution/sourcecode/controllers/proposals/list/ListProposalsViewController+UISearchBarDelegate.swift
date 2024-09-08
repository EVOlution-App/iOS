import UIKit

// MARK: - UISearchBar Delegate

struct Search {
  let query: String
}

extension ListProposalsViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBar(_: UISearchBar, textDidChange searchText: String) {
    guard searchText != "" else {
      updateTableView()
      return
    }
    
    if timer.isValid {
      timer.invalidate()
    }
    
    if searchText.count > 3 {
      let interval = 0.7
      timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
        let filtered = self.dataSource.filter(by: searchText)
        self.updateTableView(filtered)
      }
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard
      let query = searchBar.text,
      query.trimmingCharacters(in: .whitespaces) != ""
    else {
      return
    }
    
    let filtered = dataSource.filter(by: query)
    updateTableView(filtered)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()
    searchBar.text = ""
    
    updateTableView()
  }
}
