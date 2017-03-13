import UIKit

class ListEvolutionsViewController: UIViewController {

    // Private IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet fileprivate weak var filterHeaderView: FilterHeaderView!
    @IBOutlet fileprivate weak var filterHeaderViewHeightConstraint: NSLayoutConstraint!
    
    // Private properties
    fileprivate var dataSource: [Evolution] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Cell to TableView
        self.tableView.registerNib(withClass: EvolutionTableViewCell.self)
        
        self.tableView.estimatedRowHeight = 164
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Filter Header View settings
        self.filterHeaderView.statusFilterView.delegate = self
        self.filterHeaderView.languageVersionFilterView.delegate = self
        self.filterHeaderView.searchBar.delegate = self
        self.filterHeaderView.clipsToBounds = true
        
        self.filterHeaderView.filterButton.addTarget(self, action: #selector(filterButtonAction(_:)), for: .touchUpInside)
        self.filterHeaderView.filteredByButton.addTarget(self, action: #selector(filteredByButtonAction(_:)), for: .touchUpInside)
        
        self.filterHeaderView.filterLevel = .without

        
        // Request the Proposes
        self.getProposalList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.filterHeaderViewHeightConstraint.constant = self.filterHeaderView.heightForView
    }
    
    fileprivate func layoutFilterHeaderView() {
        UIView.animate(withDuration: 0.25) {
            self.filterHeaderViewHeightConstraint.constant = self.filterHeaderView.heightForView
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Requests
    fileprivate func getProposalList() {
        EvolutionService.listEvolutions { error, proposals in
            guard error == nil, let proposals = proposals else {
                return
            }

            // Descending order
            self.dataSource = proposals.sorted { $0.id > $1.id }
            
            // Status source
            self.filterHeaderView?.statusSource = [
                .awaitingReview, .scheduledForReview, .activeReview, .returnedForRevision,
                .withdrawn, .deferred, .accepted, .acceptedWithRevisions, .rejected, .implemented
            ]
            
            // Language Versions source
            self.filterHeaderView?.languageVersionSource = proposals.flatMap({ $0.status.version }).removeDuplicates().sorted()

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    func filterButtonAction(_ sender: UIButton?) {
        guard let sender = sender else { return }
        
        sender.isSelected = !sender.isSelected
        self.filterHeaderView.filterLevel = .without
        
        if !sender.isSelected {
            self.filterHeaderView.filteredByButton.isSelected = false
        }
        else {
            // Open filter until filteredByButton max height
            self.filterHeaderView.filterLevel = .filtered
            
            // If have any status selected, open to status list max height, else open to language version max height
            if let selected = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems, selected.count > 0 {
                
                self.filterHeaderView.filterLevel = .status
                if self.selected(status: .implemented) {
                    self.filterHeaderView.filterLevel = .version
                    
                    // TODO: Get language version selected and filter the proposal list
                }
            }
        }
        
        self.layoutFilterHeaderView()
    }
    
    func filteredByButtonAction(_ sender: UIButton?) {
        guard let sender = sender else { return }

        sender.isSelected = !sender.isSelected
        self.filterHeaderView.filterLevel = sender.isSelected ? .status : .filtered
        
        // If have any status selected, open to status list max height, else open to language version max height
        if let selected = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems, selected.count > 0 {
            self.filterHeaderView.filterLevel = self.selected(status: .implemented) ? .version : .status
        }

        self.layoutFilterHeaderView()
    }
    
    // MARK: - Filters
    
    fileprivate func selected(status: StatusState) -> Bool {
        guard let indexPaths = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems,
            indexPaths.flatMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == status }).count > 0 else {
            return false
        }
        return true
    }
    
    

}


// MARK: - UITableView DataSource

extension ListEvolutionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as EvolutionTableViewCell
        cell.proposal = self.dataSource[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableView Delegate

extension ListEvolutionsViewController: UITableViewDelegate {

}

// MARK: - FilterGenericView Delegate

extension ListEvolutionsViewController: FilterGenericViewDelegate {
    func didSelectedFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
        switch type {
        case .status:
            if self.filterHeaderView.statusSource[indexPath.item] == .implemented {
                self.filterHeaderView.filterLevel = .version
                self.layoutFilterHeaderView()
            }
            
            break
            
        default:
            break
        }
    }
    
    func didDeselectedFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
        switch type {
        case .status:
            if let indexPaths = view.indexPathsForSelectedItems,
                indexPaths.flatMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == .implemented }).count == 0 {
                
                self.filterHeaderView.filterLevel = .status
                self.layoutFilterHeaderView()
            }
            
            break
            
        default:
            break
        }
    }
}

// MARK: - UISearchBar Delegate

extension ListEvolutionsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange: \(searchText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}
