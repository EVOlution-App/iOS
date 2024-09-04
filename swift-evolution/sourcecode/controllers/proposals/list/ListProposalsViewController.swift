import SafariServices
import SwiftUI
import UIKit

final class ListProposalsViewController: BaseViewController {
  // Private IBOutlets
  @IBOutlet private(set) var tableView: UITableView!
  @IBOutlet private(set) var footerView: UIView!
  @IBOutlet private(set) var filterHeaderView: FilterHeaderView!
  @IBOutlet private(set) var filterHeaderViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet private(set) var settingsBarButtonItem: UIBarButtonItem?

  // Private properties
  fileprivate var timer: Timer = .init()

  fileprivate lazy var filteredDataSource: [Proposal] = []

  fileprivate var dataSource: [Proposal] = [] {
    didSet {
      guard
        oldValue.isEmpty,
        let proposal = dataSource.first,
        UIDevice.current.userInterfaceIdiom == .pad
      else {
        return
      }
      DispatchQueue.main.async { self.didSelect(proposal: proposal) }
    }
  }

  fileprivate weak var appDelegate: AppDelegate?

  // Filters
  fileprivate var languages: [Version] = []
  fileprivate var status: [StatusState] = []

  // Proposal ordering
  fileprivate lazy var statusOrder: [StatusState] = [
    .awaitingReview,
    .scheduledForReview,
    .activeReview,
    .accepted,
    .acceptedWithRevisions,
    .previewing,
    .implemented,
    .returnedForRevision,
    .deferred,
    .rejected,
    .withdrawn,
  ]

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    appDelegate = UIApplication.shared.delegate as? AppDelegate

    // Target to RefreshControl
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

    // Register Cell to TableView
    tableView.registerNib(withClass: ProposalTableViewCell.self)

    tableView.estimatedRowHeight = 164
    tableView.estimatedSectionHeaderHeight = 44.0
    tableView.rowHeight = UITableView.automaticDimension

    tableView.addSubview(refreshControl)

    // Filter Header View settings
    filterHeaderView.statusFilterView.delegate = self
    filterHeaderView.languageVersionFilterView.delegate = self
    filterHeaderView.searchBar.delegate = self
    filterHeaderView.clipsToBounds = true

    filterHeaderView.filterButton.addTarget(self, action: #selector(filter(_:)), for: .touchUpInside)
    filterHeaderView.filteredByButton.addTarget(
      self,
      action: #selector(filteredByButtonAction(_:)),
      for: .touchUpInside
    )

    filterHeaderView.filterLevel = .without

    // Notifications
    registerNotifications()

    // Request the Proposes
    getProposalList()

    // Configure reachability closures
    reachability?.whenReachable = { [weak self] _ in
      if self?.dataSource.isEmpty == true {
        self?.getProposalList()
      }
    }

    reachability?.whenUnreachable = { [weak self] _ in
      if self?.dataSource.isEmpty == true {
        self?.showNoConnection = true
      }
    }

    if let title = Environment.title, title.isEmpty == false {
      self.title = title
    }

    ProfileViewController.dismissCallback = { object in
      Config.Segues.proposalDetail.performSegue(in: self.splitViewController, with: object, split: true)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.topItem?.setRightBarButton(settingsBarButtonItem, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Layout

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    filterHeaderViewHeightConstraint.constant = filterHeaderView.heightForView
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

    getProposalList()
  }

  // MARK: - Notifications

  func registerNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didReceiveNotification(_:)),
      name: NSNotification.Name.URLScheme,
      object: nil
    )
  }

  func removeNotifications() {
    NotificationCenter.default.removeObserver(
      NSNotification.Name.URLScheme
    )
  }

  @objc func didReceiveNotification(_ notification: Notification) {
    guard notification.name == Notification.Name.URLScheme else {
      return
    }

    navigate(to: Navigation.shared)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is ProposalDetailViewController,
       let destination = segue.destination as? ProposalDetailViewController
    {
      var item: Proposal?
      if sender == nil, let indexPath = tableView.indexPathForSelectedRow {
        item = filteredDataSource[indexPath.row]
      }
      else if sender != nil, sender is Proposal {
        item = sender as? Proposal
      }

      if let proposal = item {
        destination.proposal = proposal

        if !Navigation.shared.isClear {
          Navigation.shared.clear()
        }
      }
    }
    else if segue.destination is ProfileViewController,
            let destination = segue.destination as? ProfileViewController,
            sender != nil, sender is Person, let person = sender as? Person
    {
      destination.profile = person
    }
  }

  func navigate(to navigation: Navigation?) {
    guard let navigation, !navigation.isClear else {
      return
    }

    guard
      let host = navigation.host,
      let value = navigation.value
    else {
      return
    }

    let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self

    if host == .proposal {
      let id: Int = value.regex(Config.Common.Regex.proposalID)

      guard let proposal = dataSource.get(by: id) else {
        return
      }

      Config.Segues.proposalDetail.performSegue(in: sourceViewController, with: proposal, split: true)
    }
    else if host == .profile {
      guard let appDelegate, let person = appDelegate.people.get(username: value) else {
        return
      }

      Config.Segues.profile.performSegue(in: self, with: person, formSheet: true)
    }
  }

  // MARK: - Requests

  fileprivate func getProposalList() {
    if let reachability, reachability.connection != .unavailable {
      // Hide No Connection View
      showNoConnection = false
      refreshControl.forceShowAnimation()

      EvolutionService.listProposals { [weak self] result in
        guard let self else {
          return
        }

        if !dataSource.isEmpty {
          filteredDataSource = []
          dataSource = []
          languages = []
          status = []
          appDelegate?.people = [:]
        }

        DispatchQueue.main.async {
          if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
          }
        }

        guard let proposals = result.value else {
          if let error = result.error {
            print("Error: \(error)")
          }
          return
        }

        dataSource = proposals.filter(by: statusOrder)
        filteredDataSource = dataSource
        filterHeaderView?.statusSource = statusOrder
        buildPeople()

        // Language Versions source
        filterHeaderView?.languageVersionSource = proposals.compactMap(\.status.version).removeDuplicates(
        ).sorted()

        DispatchQueue.main.async {
          self.tableView.reloadData()

          if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
          }

          // In case of user have come
          if !Navigation.shared.isClear {
            self.navigate(to: Navigation.shared)
          }
        }
      }
    }
    else {
      refreshControl.endRefreshing()
      showNoConnection = true
    }
  }

  // MARK: - Actions

  @objc func filter(_ sender: UIButton?) {
    guard let sender else {
      return
    }

    sender.isSelected = !sender.isSelected
    filterHeaderView.filterLevel = .without

    if !sender.isSelected {
      filterHeaderView.filteredByButton.isSelected = false
    }
    else {
      // Open filter until filteredByButton max height
      filterHeaderView.filterLevel = .filtered

      // If have any status selected, open to status list max height, else open to language version max height
      if let selected = filterHeaderView.statusFilterView.indexPathsForSelectedItems, !selected.isEmpty {
        filterHeaderView.filterLevel = .status
        if self.selected(status: .implemented) {
          filterHeaderView.filterLevel = .version
        }

        filterHeaderView.filteredByButton.isSelected = true
      }
    }

    updateTableView()
    layoutFilterHeaderView()
  }

  @objc func filteredByButtonAction(_ sender: UIButton?) {
    guard let sender else {
      return
    }

    sender.isSelected = !sender.isSelected
    filterHeaderView.filterLevel = sender.isSelected ? .status : .filtered

    // If have any status selected, open to status list max height, else open to language version max height
    if let selected = filterHeaderView.statusFilterView.indexPathsForSelectedItems, !selected.isEmpty,
       sender.isSelected
    {
      filterHeaderView.filterLevel = self.selected(status: .implemented) ? .version : .status
    }

    layoutFilterHeaderView()
  }

  @objc private func refresh(_: UIRefreshControl) {
    getProposalList()
  }

  // MARK: - Filters

  fileprivate func selected(status: StatusState) -> Bool {
    guard let indexPaths = filterHeaderView.statusFilterView.indexPathsForSelectedItems,
          !indexPaths.compactMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == status }).isEmpty
    else {
      return false
    }
    return true
  }

  // MARK: - Utils

  fileprivate func updateTableView(_ filtered: [Proposal]? = nil) {
    if let filtered {
      filteredDataSource = filtered
    }
    else {
      filteredDataSource = dataSource
    }

    if filterHeaderView.filterButton.isSelected {
      // Check if there is at least on status selected
      if !status.isEmpty {
        var expection: [StatusState] = [.implemented]
        if selected(status: .implemented), languages.isEmpty {
          expection = []
        }

        filteredDataSource = filteredDataSource.filter(by: status, exceptions: expection).sort(.descending)
      }

      // Check if the status selected is equal to .implemented and has language versions selected
      if selected(status: .implemented), !languages.isEmpty {
        let implemented = dataSource.filter(by: languages).filter(status: .implemented)
        filteredDataSource.append(contentsOf: implemented)
      }
    }

    // Sort in the right order
    filteredDataSource = filteredDataSource.distinct().filter(by: statusOrder)

    tableView.beginUpdates()
    tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    tableView.endUpdates()
  }

  // MARK: - Data Consolidation

  func buildPeople() {
    var people: [String: Person] = [:]

    var proposalsPeople = People()

    for proposal in dataSource {
      proposal.authors?.forEach { author in
        proposalsPeople.append(author)
      }

      if let reviewManager = proposal.reviewManager {
        proposalsPeople.append(reviewManager)
      }
    }

    for person in proposalsPeople {
      guard let name = person.name, name.isEmpty == false else {
        continue
      }

      guard people[name] == nil else {
        continue
      }

      people[name] = person

      guard var user = people[name] else {
        continue
      }

      user.id = UUID().uuidString
      user.asAuthor = dataSource.filter(author: user)
      user.asManager = dataSource.filter(manager: user)

      people[name] = user
    }

    appDelegate?.people = people
  }

  // MARK: - IBActions

  @IBAction private func openSettings() {
    openViewController(of: "SettingsStoryboardID")
  }

  private func openViewController(of storyboardID: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: storyboardID)

    if UIDevice.current.userInterfaceIdiom == .pad {
      let navigationController = UINavigationController(rootViewController: controller)
      navigationController.modalPresentationStyle = .formSheet
      present(navigationController, animated: true)
    }
    else {
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}

// MARK: - UITableView DataSource

extension ListProposalsViewController: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    filteredDataSource.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.cell(forRowAt: indexPath) as ProposalTableViewCell

    cell.delegate = self
    cell.proposal = filteredDataSource[indexPath.row]

    return cell
  }
}

// MARK: - UITableView Delegate

extension ListProposalsViewController: UITableViewDelegate {
  func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
    let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self
    Config.Segues.proposalDetail.performSegue(in: sourceViewController, split: true)
  }

  func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
    UIHostingController(
      rootView: ListHeaderView(
        count: filteredDataSource.count
      )
    )
    .view
  }

  func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
    0.01
  }
}

// MARK: - FilterGenericView Delegate

extension ListProposalsViewController: FilterGenericViewDelegate {
  func didSelectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
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

  func didDeselectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
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

// MARK: - Proposal Delegate

extension ListProposalsViewController: ProposalDelegate {
  func didSelect(person: Person) {
    guard let name = person.name else {
      return
    }

    let profile = appDelegate?.people[name]
    Config.Segues.profile.performSegue(in: self, with: profile, formSheet: true)
  }

  func didSelect(proposal: Proposal) {
    guard let proposal = dataSource.get(by: proposal.id) else {
      return
    }

    let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self
    Config.Segues.proposalDetail.performSegue(in: sourceViewController, with: proposal, split: true)
  }

  func didSelect(implementation: Implementation) {
    if let url = URL(string: "\(Config.Base.URL.GitHub.base)/\(implementation.path)") {
      let safariViewController = SFSafariViewController(url: url)
      present(safariViewController, animated: true)
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
    guard let query = searchBar.text,
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
