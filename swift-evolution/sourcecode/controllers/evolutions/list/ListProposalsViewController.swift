import UIKit

class ListProposalsViewController: BaseViewController {
    
    // Private IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet fileprivate weak var filterHeaderView: FilterHeaderView!
    @IBOutlet fileprivate weak var filterHeaderViewHeightConstraint: NSLayoutConstraint!
    
    // Private properties
    fileprivate var timer: Timer = Timer()
    fileprivate var filteredDataSource: [Proposal] = []
    fileprivate var dataSource: [Proposal] = []
    
    // Filters
    fileprivate var languages: [Version] = []
    fileprivate var status: [StatusState] = []
    fileprivate var totalFilters = 0
    
    // Proposal ordering
    fileprivate lazy var statusOrder: [StatusState] = {
        return [.awaitingReview, .scheduledForReview, .activeReview,
                .returnedForRevision, .accepted, .implemented,
                .deferred, .rejected, .withdrawn]
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell to TableView
        self.tableView.registerNib(withClass: ProposalTableViewCell.self)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable Rotation
        self.rotate = false
        
        // Force rotation back to portrait
        Config.Orientation.portrait()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProposalDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let destination = segue.destination as? ProposalDetailViewController {
            
            let item = self.filteredDataSource[indexPath.row]
            destination.proposal = item
        }
    }
    
    
    // MARK: - Requests
    fileprivate func getProposalList() {
        EvolutionService.listProposals { error, proposals in
            guard error == nil, let proposals = proposals else {
                return
            }
            
            self.dataSource = proposals.filter(by: self.statusOrder)
            self.filteredDataSource = self.dataSource
            
            self.filterHeaderView?.statusSource = self.statusOrder
            
            // Language Versions source
            self.filterHeaderView?.languageVersionSource = proposals.flatMap({ $0.status.version }).removeDuplicates().sorted()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    func filterButtonAction(_ sender: UIButton?) {
        guard let sender = sender else {
            return
        }
        
        sender.isSelected = !sender.isSelected
        self.filterHeaderView.filterLevel = .without
        
        if !sender.isSelected {
            self.filterHeaderView.filteredByButton.isSelected = false
            self.filterHeaderView.filterButton.badgeValue = "\(self.totalFilters)"
        }
        else {
            // Open filter until filteredByButton max height
            self.filterHeaderView.filterButton.badgeValue = ""
            self.filterHeaderView.filterLevel = .filtered
            
            // If have any status selected, open to status list max height, else open to language version max height
            if let selected = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems, selected.count > 0 {
                
                self.filterHeaderView.filterLevel = .status
                if self.selected(status: .implemented) {
                    self.filterHeaderView.filterLevel = .version
                }
            }
        }
        
        self.updateTableView()
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
    
    func fireSearch(_ timer: Timer) {
        guard let search = timer.userInfo as? Search else {
            return
        }
        
        let filtered = self.dataSource.filter(by: search.query)
        self.updateTableView(filtered)
    }
    
    // MARK: - Filters
    
    fileprivate func selected(status: StatusState) -> Bool {
        guard let indexPaths = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems,
            indexPaths.flatMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == status }).count > 0 else {
                return false
        }
        return true
    }
    
    // MARK: - Utils
    
    fileprivate func updateTableView(_ filtered: [Proposal]? = nil) {
        if let filtered = filtered {
            self.filteredDataSource = filtered
        }
        else {
            self.filteredDataSource = self.dataSource
        }
        
            
            // Check if there is at least on status selected
        if self.status.count > 0 {
            var expection: [StatusState] = [.implemented]
            if self.selected(status: .implemented) && self.languages.count == 0 {
                expection = []
            }
                
            self.filteredDataSource = self.filteredDataSource.filter(by: self.status, exceptions: expection).sort(.descending)
        }
            
            // Check if the status selected is equal to .implemented and has language versions selected
        if self.selected(status: .implemented) && self.languages.count > 0 {
            let implemented = self.dataSource.filter(by: self.languages).filter(status: .implemented)
            self.filteredDataSource.append(contentsOf: implemented)
        }
        
        // Sort in the right order
        self.filteredDataSource = self.filteredDataSource.distinct().filter(by: self.statusOrder)
        
        self.tableView.beginUpdates()
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        self.tableView.endUpdates()
    }
}


// MARK: - UITableView DataSource

extension ListProposalsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalTableViewCell
        cell.proposal = self.filteredDataSource[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableView Delegate

extension ListProposalsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Config.Segues.proposalDetail.performSegue(in: self)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

// MARK: - FilterGenericView Delegate

extension ListProposalsViewController: FilterGenericViewDelegate {
    func didSelectedFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
        switch type {
        case .status:
            if self.filterHeaderView.statusSource[indexPath.item] == .implemented {
                self.filterHeaderView.filterLevel = .version
                self.layoutFilterHeaderView()
                
                self.languages = []
            }
            
            if let item: StatusState = view.dataSource[indexPath.item] as? StatusState {
                self.status.append(item)
                
            }
            
            self.updateTableView()
            
            
            break
            
        case .version:
            if let version = view.dataSource[indexPath.item] as? String {
                self.languages.append(version)
            }
            
            self.updateTableView()
            
            break
            
        default:
            break
        }
        totalFilters += 1
    }
    
    func didDeselectedFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
        let item = view.dataSource[indexPath.item]
        
        switch type {
        case .status:
            if let indexPaths = view.indexPathsForSelectedItems,
                indexPaths.flatMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == .implemented }).count == 0 {
                
                self.filterHeaderView.filterLevel = .status
                self.layoutFilterHeaderView()
            }
            
            
            if let status = item as? StatusState, self.status.remove(status) {
                self.updateTableView()
            }
            
            break
            
        case .version:
            if self.languages.remove(string: item.description) {
                self.updateTableView()
            }
            
            break
            
        default:
            break
        }
        totalFilters -= 1
    }
}

// MARK: - UISearchBar Delegate

struct Search {
    let query: String
}

extension ListProposalsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.timer.isValid {
            self.timer.invalidate()
        }
        
        if searchText.characters.count > 3 {
            let interval = 0.7
            if #available(iOS 10.0, *) {
                self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { timer in
                    let filtered = self.dataSource.filter(by: searchText)
                    self.updateTableView(filtered)
                }
            }
            else {
                let search = Search(query: searchText)
                self.timer = Timer.scheduledTimer(timeInterval: interval,
                                                  target: self,
                                                  selector: #selector(fireSearch(_:)),
                                                  userInfo: search,
                                                  repeats: false)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
            query.trimmingCharacters(in: .whitespaces) != ""
            else {
                return
        }
        
        let filtered = self.dataSource.filter(by: query)
        self.updateTableView(filtered)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        self.updateTableView()
    }
}

