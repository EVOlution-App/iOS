import UIKit
import SwiftUI

class ProfileViewController: BaseViewController {

    fileprivate struct Section {
        let title: String
        let proposals: [Proposal]
    }

    static var dismissCallback: ((Any?) -> Void)?
    
    @IBOutlet private weak var profileView: ProfileView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var toolbarTopYConstraint: NSLayoutConstraint!

    open var profile: Person?
    fileprivate lazy var sections: [Section] = {
        return []
    }()

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell to TableView
        self.tableView.registerNib(withClass: ProposalTableViewCell.self)
        
        self.tableView.estimatedRowHeight = 164
        self.tableView.estimatedSectionHeaderHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension

        if UIDevice.current.userInterfaceIdiom != .pad {
            toolbar?.items?.removeAll()
            toolbarTopYConstraint.constant = -44
            view.layoutIfNeeded()
        }

        // Settings
        self.showNoConnection = false
        self.profileView.profile = profile
        self.userDataFromGitHub()
        self.tableView.reloadData()
        
        // Title
        if let profile, let username = profile.username {
            self.title = "@\(username)"
        }
        
        self.configureSections()
        
        // Configure reachability closures
        self.reachability?.whenReachable = { [unowned self] reachability in
            if self.profileView.imageURL == nil {
                self.userDataFromGitHub()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProposalDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let destination = segue.destination as? ProposalDetailViewController {
            
            let section = self.sections[indexPath.section]
            let proposal = section.proposals[indexPath.row]
            
            destination.proposal = proposal
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }

}

// MARK: - Requests
extension ProfileViewController {
    fileprivate func configureSections() {
        guard let profile = self.profile else {
            return
        }
        
        if let author = profile.asAuthor, author.count > 0 {
            let section = Section(title: "Author", proposals: author)
            sections.append(section)
        }
        
        if let manager = profile.asManager, manager.count > 0 {
            let section = Section(title: "Review Manager", proposals: manager)
            sections.append(section)
        }
        
        self.tableView.reloadData()
    }
    
    private func userDataFromGitHub() {
        guard let profile, let username = profile.username else {
            return
        }
        
        if let reachability, reachability.connection != .unavailable {
            GitHubService.profile(from: username) { [weak self] result in
                guard let github = result.value else {
                    return
                }
                self?.profile?.github = github
                self?.profileView.imageURL = github.avatar
            }
        }
    }
}


// MARK: - UITableView DataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = self.sections.count
        
        guard sections > 0 else {
            return 0
        }

        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].proposals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalTableViewCell
        
        let section = self.sections[indexPath.section]
        let proposal = section.proposals[indexPath.row]
        
        cell.proposal = proposal
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self

        if modalPresentationStyle == .formSheet {
            dismiss(animated: true) {
                ProfileViewController.dismissCallback?(self.sections[indexPath.section].proposals[indexPath.row])
            }
        } else {
            Config.Segues.proposalDetail.performSegue(in: sourceViewController, split: true)
        }
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        
        return UIHostingController(
            rootView: ListHeaderView(
                title: section.title
            )
        )
        .view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
