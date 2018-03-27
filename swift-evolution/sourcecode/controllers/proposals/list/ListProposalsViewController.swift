import UIKit
import Crashlytics
import SafariServices

class ListProposalsViewController: BaseViewController {
    
    // Private IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet fileprivate weak var filterHeaderView: FilterHeaderView!
    @IBOutlet fileprivate weak var filterHeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var aboutBarButtonItem: UIBarButtonItem?

    // Private properties
    fileprivate var timer: Timer = Timer()
    fileprivate lazy var filteredDataSource: [Proposal] = {
        return []
    }()
    
    fileprivate var dataSource: [Proposal] = {
        return []
        }() {
        didSet {
            guard
                oldValue.isEmpty,
                let proposal = dataSource.first,
                UIDevice.current.userInterfaceIdiom == .pad
                else { return }
            DispatchQueue.main.async { self.didSelect(proposal: proposal) }
        }
    }
    
    fileprivate weak var appDelegate: AppDelegate?
    
    // Filters
    fileprivate var languages: [Version] = []
    fileprivate var status: [StatusState] = []
    
    // Proposal ordering
    fileprivate lazy var statusOrder: [StatusState] = {
        return [.awaitingReview, .scheduledForReview, .activeReview,
                .returnedForRevision, .accepted, .acceptedWithRevisions, .implemented,
                .deferred, .rejected, .withdrawn]
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // Register Cell to TableView
        self.tableView.registerNib(withClass: ProposalTableViewCell.self)
        self.tableView.registerNib(withClass: ProposalListHeaderTableViewCell.self)
        
        self.tableView.estimatedRowHeight = 220
        self.tableView.estimatedSectionHeaderHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Filter Header View settings
        self.filterHeaderView.statusFilterView.delegate = self
        self.filterHeaderView.languageVersionFilterView.delegate = self
        self.filterHeaderView.searchBar.delegate = self
        self.filterHeaderView.clipsToBounds = true
        
        self.filterHeaderView.filterButton.addTarget(self, action: #selector(filterButtonAction(_:)), for: .touchUpInside)
        self.filterHeaderView.filteredByButton.addTarget(self, action: #selector(filteredByButtonAction(_:)), for: .touchUpInside)
        
        self.filterHeaderView.filterLevel = .without
        
        Answers.logContentView(withName: "Proposal List",
                               contentType: "Load View",
                               contentId: nil,
                               customAttributes: nil)
        
        // Notifications
        self.registerNotifications()
        
        // Request the Proposes
        self.getProposalList()
        
        // Configure reachability closures
        self.reachability?.whenReachable = { [unowned self] reachability in
            if self.dataSource.count == 0 {
                self.getProposalList()
            }
        }
        
        self.reachability?.whenUnreachable = { [unowned self] reachability in
            if self.dataSource.count == 0 {
                self.showNoConnection = true
            }
        }
        
        if let title = Environment.title, title != "" {
            self.title = title
        }

        ProfileViewController.dismissCallback = { object in
            Config.Segues.proposalDetail.performSegue(in: self.splitViewController, with: object, split: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.setRightBarButton(self.aboutBarButtonItem, animated: true)
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
    
    deinit {
        self.removeNotifications()
    }
    
    // MARK: - Reachability Retry Action
    override func retryButtonAction(_ sender: UIButton) {
        super.retryButtonAction(sender)

        self.getProposalList()
    }
    
    // MARK: - Notifications
    func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNotification(_:)),
                                               name: NSNotification.Name.URLScheme,
                                               object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(NSNotification.Name.URLScheme)
    }
    
    @objc func didReceiveNotification(_ notification: Notification) {
        guard let info = notification.userInfo else { return }//,
        self.navigateTo(info["Host"], info["Value"])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProposalDetailViewController,
            let destination = segue.destination as? ProposalDetailViewController {
            
            var item: Proposal? = nil
            if sender == nil, let indexPath = self.tableView.indexPathForSelectedRow {
                item = self.filteredDataSource[indexPath.row]
            }
            else if sender != nil, sender is Proposal {
                item = sender as? Proposal
            }
            
            if let proposal = item {
                destination.proposal = proposal
            }
        }
        else if segue.destination is ProfileViewController,
            let destination = segue.destination as? ProfileViewController,
            sender != nil, sender is Person, let person = sender as? Person {
            
            destination.profile = person
        }
    }
    
    func navigateTo(_ host: Any?, _ value: Any?) {

        let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self

        guard host is Host, let host = host as? Host,
            value is String, let value = value as? String else {
                return
        }
        
        if host == .proposal {
            let id: Int = value.regex(Config.Common.Regex.proposalID)
            if let proposal = self.dataSource.get(by: id) {
                Config.Segues.proposalDetail.performSegue(in: sourceViewController, with: proposal, split: true)
            }
        }
        else if host == .profile {
            if let appDelegate = self.appDelegate,
                let person = appDelegate.people.get(username: value) {
                Config.Segues.profile.performSegue(in: self, with: person, formSheet: true)
            }
        }
        
        // Invalidate host and value after use
        self.appDelegate?.host = nil
        self.appDelegate?.value = nil
    }
    
    // MARK: - Requests
    fileprivate func getProposalList() {
        if let reachability = self.reachability, reachability.isReachable {
            // Hide No Connection View
            self.showNoConnection = false

            EvolutionService.listProposals { [unowned self] result in
                guard let proposals = result.value else {
                    if let error = result.error {
                        print("Error: \(error)")
                        Crashlytics.sharedInstance().recordError(error)
                    }
                    return
                }
                
                Answers.logContentView(withName: "Proposal List",
                                       contentType: "Load Proposals from server",
                                       contentId: nil,
                                       customAttributes: nil)
                
                self.dataSource = proposals.filter(by: self.statusOrder)
                self.filteredDataSource = self.dataSource
                
                self.filterHeaderView?.statusSource = self.statusOrder
                
                self.buildPeople()
                
                // Language Versions source
                self.filterHeaderView?.languageVersionSource = proposals.flatMap({ $0.status.version }).removeDuplicates().sorted()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    // In case of user have come
                    self.navigateTo(self.appDelegate?.host, self.appDelegate?.value)
                }
            }
        }
        else {
            self.showNoConnection = true
        }
    }
    
    // MARK: - Actions
    @objc func filterButtonAction(_ sender: UIButton?) {
        guard let sender = sender else {
            return
        }
        
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
                }
                
                self.filterHeaderView.filteredByButton.isSelected = true
            }
        }
        
        self.updateTableView()
        self.layoutFilterHeaderView()
    }
    
    @objc func filteredByButtonAction(_ sender: UIButton?) {
        guard let sender = sender else { return }
        
        sender.isSelected = !sender.isSelected
        self.filterHeaderView.filterLevel = sender.isSelected ? .status : .filtered
        
        // If have any status selected, open to status list max height, else open to language version max height
        if let selected = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems, selected.count > 0, sender.isSelected {
            self.filterHeaderView.filterLevel = self.selected(status: .implemented) ? .version : .status
        }
        
        self.layoutFilterHeaderView()
    }
    
    @objc func fireSearch(_ timer: Timer) {
        guard let search = timer.userInfo as? Search else {
            return
        }
        
        Answers.logSearch(withQuery: search.query, customAttributes: ["type": "search", "os-version": "<= ios9"])
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
        
        if self.filterHeaderView.filterButton.isSelected {
            
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
        }
        
        // Sort in the right order
        self.filteredDataSource = self.filteredDataSource.distinct().filter(by: self.statusOrder)
        
        self.tableView.beginUpdates()
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        self.tableView.endUpdates()
    }
    
    // MARK: - Data Consolidation
    
    func buildPeople() {
        var authors: [String: Person] = [:]
        
        self.dataSource.forEach { proposal in
            proposal.authors?.forEach { person in
                guard let name = person.name, name != "" else {
                    return
                }
                
                guard authors[name] == nil else {
                    return
                }
                
                authors[name] = person
                
                guard var user = authors[name] else {
                    return
                }
                
                user.id = UUID().uuidString
                user.asAuthor = self.dataSource.filter(author: user)
                user.asManager = self.dataSource.filter(manager: user)
                
                authors[name] = user
            }
        }

        self.appDelegate?.people = authors
    }

    // MARK: - IBActions
    @IBAction func about() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AboutStoryboardID")
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.modalPresentationStyle = .formSheet
            present(controller, animated: true)
        } else {
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}


// MARK: - UITableView DataSource

extension ListProposalsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalTableViewCell
        
        cell.delegate = self
        cell.proposal = self.filteredDataSource[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableView Delegate

extension ListProposalsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self
        Config.Segues.proposalDetail.performSegue(in: sourceViewController, split: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !dataSource.isEmpty else {
            return nil
        }
        
        let headerCell = tableView.cell(forClass: ProposalListHeaderTableViewCell.self)

        headerCell.proposalCount = self.filteredDataSource.count
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

// MARK: - FilterGenericView Delegate

extension ListProposalsViewController: FilterGenericViewDelegate {
    func didSelectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
        switch type {
        case .status:
            if self.filterHeaderView.statusSource[indexPath.item] == .implemented {
                self.filterHeaderView.filterLevel = .version
                self.layoutFilterHeaderView()
                
                self.languages = []
            }
            
            if let item: StatusState = view.dataSource[indexPath.item] as? StatusState {
                Answers.logSearch(withQuery: item.rawValue.className, customAttributes: ["type": "filter"])
                self.status.append(item)
            }
            
            self.updateTableView()
            
        case .version:
            if let version = view.dataSource[indexPath.item] as? String {
                Answers.logSearch(withQuery: version, customAttributes: ["type": "filter", "subtype": "language-version"])
                self.languages.append(version)
            }
            
            self.updateTableView()
            
        default:
            break
        }
        self.filterHeaderView.updateFilterButton(status: self.status)
    }
    
    func didDeselectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
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
            
        case .version:
            if self.languages.remove(string: item.description) {
                self.updateTableView()
            }
            
        default:
            break
        }
        self.filterHeaderView.updateFilterButton(status: self.status)
    }
}


// MARK: - Proposal Delegate

extension ListProposalsViewController: ProposalDelegate {
    func didSelect(person: Person) {
        guard let name = person.name else {
            return
        }

        let profile = self.appDelegate?.people[name]
        Config.Segues.profile.performSegue(in: self, with: profile, formSheet: true)
    }
    
    func didSelect(proposal: Proposal) {
        guard let proposal = self.dataSource.get(by: proposal.id) else {
            return
        }

        let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self
        Config.Segues.proposalDetail.performSegue(in: sourceViewController, with: proposal, split: true)
    }
    
    func didSelect(implementation: Implementation) {
        if let url = URL(string: "\(Config.Base.URL.github)/\(implementation.path)") {
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(safariViewController, animated: true)
        }
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
        guard searchText != "" else {
            self.updateTableView()
            return
        }
        
        if self.timer.isValid {
            self.timer.invalidate()
        }
        
        if searchText.count > 3 {
            let interval = 0.7
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                Answers.logSearch(withQuery: searchText, customAttributes: ["type": "search", "os-version": ">= ios10"])
                
                let filtered = self.dataSource.filter(by: searchText)
                self.updateTableView(filtered)
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
