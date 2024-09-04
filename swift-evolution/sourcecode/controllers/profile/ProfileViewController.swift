import SwiftUI
import UIKit

class ProfileViewController: BaseViewController {
  fileprivate struct Section {
    let title: String
    let proposals: [Proposal]
  }

  static var dismissCallback: ((Any?) -> Void)?

  @IBOutlet private var profileView: ProfileView!
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var toolbar: UIToolbar!
  @IBOutlet private var toolbarTopYConstraint: NSLayoutConstraint!

  open var profile: Person?
  fileprivate lazy var sections: [Section] = []

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Register Cell to TableView
    tableView.registerNib(withClass: ProposalTableViewCell.self)

    tableView.estimatedRowHeight = 164
    tableView.estimatedSectionHeaderHeight = 44.0
    tableView.rowHeight = UITableView.automaticDimension

    if UIDevice.current.userInterfaceIdiom != .pad {
      toolbar?.items?.removeAll()
      toolbarTopYConstraint.constant = -44
      view.layoutIfNeeded()
    }

    // Settings
    showNoConnection = false
    profileView.profile = profile
    userDataFromGitHub()
    tableView.reloadData()

    // Title
    if let profile, let username = profile.username {
      title = "@\(username)"
    }

    configureSections()

    // Configure reachability closures
    reachability?.whenReachable = { [unowned self] _ in
      if profileView.imageURL == nil {
        userDataFromGitHub()
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    if segue.destination is ProposalDetailViewController,
       let indexPath = tableView.indexPathForSelectedRow,
       let destination = segue.destination as? ProposalDetailViewController
    {
      let section = sections[indexPath.section]
      let proposal = section.proposals[indexPath.row]

      destination.proposal = proposal
    }
  }

  @IBAction func closeAction(_: Any) {
    dismiss(animated: true)
  }
}

// MARK: - Requests

extension ProfileViewController {
  private func configureSections() {
    guard let profile else {
      return
    }

    if let author = profile.asAuthor, !author.isEmpty {
      let section = Section(title: "Author", proposals: author)
      sections.append(section)
    }

    if let manager = profile.asManager, !manager.isEmpty {
      let section = Section(title: "Review Manager", proposals: manager)
      sections.append(section)
    }

    tableView.reloadData()
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
  func numberOfSections(in _: UITableView) -> Int {
    let sections = sections.count

    guard sections > 0 else {
      return 0
    }

    return sections
  }

  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    sections[section].proposals.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.cell(forRowAt: indexPath) as ProposalTableViewCell

    let section = sections[indexPath.section]
    let proposal = section.proposals[indexPath.row]

    cell.proposal = proposal

    return cell
  }
}

// MARK: - UITableView Delegate

extension ProfileViewController: UITableViewDelegate {
  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self

    if modalPresentationStyle == .formSheet {
      dismiss(animated: true) {
        ProfileViewController.dismissCallback?(self.sections[indexPath.section].proposals[indexPath.row])
      }
    }
    else {
      Config.Segues.proposalDetail.performSegue(in: sourceViewController, split: true)
    }
  }

  func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let section = sections[section]

    return UIHostingController(
      rootView: ListHeaderView(
        title: section.title
      )
    )
    .view
  }

  func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
    0.01
  }
}
