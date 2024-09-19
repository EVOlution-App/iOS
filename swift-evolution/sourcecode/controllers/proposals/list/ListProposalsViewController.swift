// swiftlint:disable file_length

import SafariServices
import SwiftUI
import UIKit

import ModelsLibrary
import NetworkLibrary

protocol ListProposalsViewControllerDelegate: AnyObject {
  func listProposalsViewController(
    _ viewController: ListProposalsViewController,
    didSelect proposal: Proposal
  )
}

final class ListProposalsViewController: BaseViewController {
  // Private IBOutlets
  @IBOutlet private(set) var tableView: UITableView!
  @IBOutlet private(set) var footerView: UIView!
  @IBOutlet private(set) var filterHeaderView: FilterHeaderView!
  @IBOutlet private(set) var filterHeaderViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet private(set) var settingsBarButtonItem: UIBarButtonItem?

  weak var delegate: ListProposalsViewControllerDelegate?

  // Private properties
  var timer: Timer = .init()

  private lazy var filteredDataSource: [Proposal] = []

  private(set) var dataSource: [Proposal] = [] {
    didSet {
      guard
        oldValue.isEmpty,
        let proposal = dataSource.first,
        UIDevice.current.userInterfaceIdiom == .pad
      else {
        return
      }
      DispatchQueue.main.async {
        // self.didSelect(proposal: proposal)
      }
    }
  }

  private var viewModel: ListProposalsViewModel!

  private(set) weak var appDelegate: AppDelegate?

  // Filters
  var languages: [Version] = []
  var status: [StatusState] = []

  // Status sorted like the website
  private lazy var statusSorted: [StatusState] = [
    .awaitingReview,
    .scheduledForReview,
    .activeReview,
    .accepted,
    .acceptedWithRevisions,
    .previewing,
    .implemented,
    .returnedForRevision,
    .rejected,
    .withdrawn,
  ]

  // MARK: - Deinit

  deinit {
    self.removeNotifications()
  }

  // MARK: - Reachability Retry

  override func retry() {
    super.retry()

    listProposals()
  }
}

// MARK: - Initializer

extension ListProposalsViewController {
  static func create(viewModel: ListProposalsViewModel) -> Self {
    let viewController = Self.loadFromNib()
    viewController.viewModel = viewModel

    return viewController
  }
}

// MARK: - Life Cycle

extension ListProposalsViewController {
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
      action: #selector(filtered(by:)),
      for: .touchUpInside
    )

    filterHeaderView.filterLevel = .without

    // Notifications
    registerNotifications()

    // Request the Proposes
    listProposals()

    // Configure reachability closures
    reachability?.whenReachable = { [weak self] _ in
      if self?.dataSource.isEmpty == true {
        self?.listProposals()
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

  // MARK: - Layout

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    filterHeaderViewHeightConstraint.constant = filterHeaderView.heightForView
  }

  func layoutFilterHeaderView() {
    UIView.animate(withDuration: 0.25) {
      self.filterHeaderViewHeightConstraint.constant = self.filterHeaderView.heightForView
      self.view.layoutIfNeeded()
    }
  }

  // MARK: - Notifications

  func registerNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(notification(_:)),
      name: NSNotification.Name.URLScheme,
      object: nil
    )
  }

  func removeNotifications() {
    NotificationCenter.default.removeObserver(
      NSNotification.Name.URLScheme
    )
  }

  @objc func notification(_ notification: Any) {
    guard
      let notification = notification as? Notification,
      notification.name == Notification.Name.URLScheme
    else {
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
    else if
      segue.destination is ProfileViewController,
      let destination = segue.destination as? ProfileViewController,
      sender != nil,
      sender is Person,
      let person = sender as? Person
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

    switch host {
    case .profile:
      guard let appDelegate, let person = appDelegate.people.get(username: value) else {
        return
      }

      Config.Segues.profile.performSegue(in: self, with: person, formSheet: true)

    case .proposal:
      let identifier: Int = value.regex(Config.Common.Regex.proposalIdentifier)

      guard let proposal = dataSource.get(by: identifier) else {
        return
      }

      Config.Segues.proposalDetail.performSegue(in: sourceViewController, with: proposal, split: true)

    default:
      break
    }
  }

  // MARK: - Requests

  private func listProposals() {
    guard let reachability, reachability.connection != .unavailable else {
      refreshControl.endRefreshing()
      showNoConnection = true

      return
    }

    // Hide No Connection View
    showNoConnection = false
    refreshControl.forceShowAnimation()

    EvolutionService.listProposals { [weak self] result in
      guard let self else {
        return
      }

      if dataSource.isEmpty == false {
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

      dataSource = proposals.filter(by: statusSorted)
      filteredDataSource = dataSource
      filterHeaderView?.statusSource = statusSorted
      buildPeople()

      // Language Versions source
      filterHeaderView?.languageVersionSource = proposals
        .compactMap(\.status.version)
        .removeDuplicates()
        .sorted()

      DispatchQueue.main.async {
        self.tableView.reloadData()

        if self.refreshControl.isRefreshing {
          self.refreshControl.endRefreshing()
        }

        // In case of user have come
        if Navigation.shared.isClear == false {
          self.navigate(to: Navigation.shared)
        }
      }
    }
  }

  // MARK: - Actions

  @objc func filter(_ sender: UIButton?) {
    guard let sender else {
      return
    }

    sender.isSelected.toggle()
    filterHeaderView.filterLevel = .without

    if !sender.isSelected {
      filterHeaderView.filteredByButton.isSelected = false
    }
    else {
      // Open filter until filteredByButton max height
      filterHeaderView.filterLevel = .filtered

      // If have any status selected, open to status list max height, else open to language version max height
      if let selected = filterHeaderView.statusFilterView.indexPathsForSelectedItems, selected.isEmpty == false {
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

  @objc func filtered(by sender: UIButton?) {
    guard let sender else {
      return
    }

    sender.isSelected.toggle()
    filterHeaderView.filterLevel = sender.isSelected ? .status : .filtered

    // If have any status selected, open to status list max height, else open to language version max height
    if
      let selected = filterHeaderView.statusFilterView.indexPathsForSelectedItems,
      selected.isEmpty == false,
      sender.isSelected
    {
      filterHeaderView.filterLevel = self.selected(status: .implemented) ? .version : .status
    }

    layoutFilterHeaderView()
  }

  @objc private func refresh(_: UIRefreshControl) {
    listProposals()
  }

  // MARK: - Filters

  private func selected(status: StatusState) -> Bool {
    guard
      let indexPaths = filterHeaderView.statusFilterView.indexPathsForSelectedItems,
      indexPaths
      .compactMap({ self.filterHeaderView.statusSource[$0.item] })
      .filter({ $0 == status })
      .isEmpty == false
    else {
      return false
    }
    return true
  }

  // MARK: - Utils

  func updateTableView(_ filtered: [Proposal]? = nil) {
    if let filtered {
      filteredDataSource = filtered
    }
    else {
      filteredDataSource = dataSource
    }

    if filterHeaderView.filterButton.isSelected {
      // Check if there is at least on status selected
      if status.isEmpty == false {
        var exceptions: [StatusState] = [.implemented]

        if selected(status: .implemented), languages.isEmpty {
          exceptions = []
        }

        filteredDataSource = filteredDataSource
          .filter(
            by: status,
            exceptions: exceptions
          )
          .sort(.descending)
      }

      // Check if the status selected is equal to .implemented and has language versions selected
      if selected(status: .implemented), languages.isEmpty == false {
        let implemented = dataSource.filter(by: languages).filter(status: .implemented)
        filteredDataSource.append(contentsOf: implemented)
      }
    }

    // Sort in the right order
    filteredDataSource = filteredDataSource
      .distinct()
      .filter(by: statusSorted)

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

      if let reviewManager = proposal.reviewManagers?.first {
        proposalsPeople.append(reviewManager)
      }
    }

    for person in proposalsPeople {
      let name = person.name
      guard name.isEmpty == false else {
        continue
      }

      guard people[name] == nil else {
        continue
      }

      people[name] = person

      guard var user = people[name] else {
        continue
      }

      user.identifier = UUID.newIdentifier
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

  private func openViewController(of storyboardName: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: storyboardName)

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
    let cell = tableView.cell(at: indexPath) as ProposalTableViewCell

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
    ListHeaderView(
      count: filteredDataSource.count
    )
    .toUIView()
  }

  func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
    0.01
  }
}

// swiftlint:enable file_length
