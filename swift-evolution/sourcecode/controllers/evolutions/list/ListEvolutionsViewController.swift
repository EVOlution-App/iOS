import UIKit

class ListEvolutionsViewController: UIViewController {

    // Private IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // Private properties
    fileprivate var dataSource: [Evolution] = []
    fileprivate var filterHeaderView: FilterHeaderView?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Cell to TableView
        self.tableView.registerNib(withClass: EvolutionTableViewCell.self)
        
        self.tableView.estimatedRowHeight = 164
        self.tableView.rowHeight = UITableViewAutomaticDimension
        

        if let filterHeaderView = FilterHeaderView.fromNib() as? FilterHeaderView {
            self.filterHeaderView = filterHeaderView
            
            // Status source
            self.filterHeaderView?.statusSource = [
                .awaitingReview, .scheduledForReview, .activeReview, .returnedForRevision,
                .withdrawn, .deferred, .accepted, .acceptedWithRevisions, .rejected, .implemented
            ]
            
            self.tableView.tableHeaderView = self.filterHeaderView
        }
        
        // Request the Proposes
        self.getProposalList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Requests
    func getProposalList() {
        EvolutionService.listEvolutions { error, proposals in
            guard error == nil, let proposals = proposals else {
                return
            }

            self.dataSource = proposals
            
            // Language Versions source
            self.filterHeaderView?.languageVersionSource = proposals.flatMap({ $0.status.version }).removeDuplicates().map({ "Swift \($0)"}).sorted()

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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

// MARK:- UITableView Delegate

extension ListEvolutionsViewController: UITableViewDelegate {

}
