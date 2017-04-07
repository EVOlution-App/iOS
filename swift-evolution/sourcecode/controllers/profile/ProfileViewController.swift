import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet fileprivate weak var profileView: ProfileView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    open var profile: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell to TableView
        self.tableView.registerNib(withClass: ProposalTableViewCell.self)
        self.tableView.registerNib(withClass: ProposalListHeaderTableViewCell.self)
        
        self.tableView.estimatedRowHeight = 164
        self.tableView.estimatedSectionHeaderHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Settings
        self.profileView.profile = profile
        self.requestUserDataFromGithub()
        self.tableView.reloadData()
        
        // Title
        if let profile = self.profile, let username = profile.username {
            self.title = "@\(username)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //self.navigationController?.backgroundTransparent()
    }
}

// MARK: - Requests
extension ProfileViewController {
    fileprivate func requestUserDataFromGithub() {
        guard let profile = self.profile, let username = profile.username else {
            return
        }
        
        GithubService.profile(from: username) { [weak self] error, github in
            guard let github = github, error == nil else {
                return
            }
            
            self?.profile?.github = github
            self?.profileView.imageURL = github.avatar
        }
    }
}


// MARK: - UITableView DataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        
        guard let profile = self.profile else {
            return sections
        }
        
        if let author = profile.asAuthor, author.count > 0 {
            sections += 1
        }
        
        if let manager = profile.asManager, manager.count > 0 {
            sections += 1
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countFor(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalTableViewCell
        
        if let proposal = self.proposalFor(indexPath) {
            cell.proposal = proposal
        }
        return cell
    }
}

// MARK: - UITableView Delegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.cell(forClass: ProposalListHeaderTableViewCell.self)
        
        headerCell.header = self.headerFor(section)
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


extension ProfileViewController {
    func headerFor(_ section: Int) -> String {
        var title = ""
        
        guard let profile = self.profile else {
            return title
        }
        
        if let author = profile.asAuthor, author.count > 0 {
            title = "As Author"
        }
        
        if section == 0, let manager = profile.asManager, manager.count > 0 {
            title = "As Review Manager"
        }
        
        return title
    }
    
    func countFor(_ section: Int) -> Int {
        var rows = 0
        
        guard let profile = self.profile else {
            return rows
        }
        
        if let author = profile.asAuthor, author.count > 0 {
            rows = author.count
        }
        
        if section == 0, let manager = profile.asManager, manager.count > 0 {
            rows = manager.count
        }
        
        return rows
    }
    
    func proposalFor(_ indexPath: IndexPath) -> Proposal? {
        var proposal: Proposal?
        
        guard let profile = self.profile else {
            return nil
        }
        
        if let author = profile.asAuthor, author.count > 0 {
            proposal = author[indexPath.row]
        }
        
        if indexPath.section == 0, let manager = profile.asManager, manager.count > 0 {
            proposal = manager[indexPath.row]
        }
        
        return proposal
    }
}


