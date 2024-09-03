import UIKit

final class SettingsTableViewController: UITableViewController {

    // MARK: - Private properties
    private var dataSource: [Section] = []
    private weak var appDelegate: AppDelegate?
    
    private lazy var descriptionView: DescriptionView? = {
        guard
            let view: DescriptionView = DescriptionView.fromNib()
            else {
                return nil
        }
        
        return view
    }()
    
    // MARK: - Life cycle
  override func viewDidLoad() {
      super.viewDidLoad()

      setupAppDelegate()
      configureUI()
      setupTableView()
      setupDescriptionView()
  }

  private func setupAppDelegate() {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
          self.appDelegate = appDelegate
      }
  }

  private func configureUI() {
      tableView.backgroundColor = UIColor(named: "BgColor")
      title = "Settings"
  }

  private func setupTableView() {
      buildDataSource()
      registerNotifications()

      tableView.registerNib(withClass: SwitchTableViewCell.self)
      tableView.registerNib(withClass: CustomSubtitleTableViewCell.self)
  }

  private func setupDescriptionView() {
      descriptionView?.delegate = self
      tableView.tableHeaderView = descriptionView
  }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getDetails(from: User.current)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        removeNotifications()
    }
    
    // MARK: - Build data
    private func buildDataSource() {
        // FIXME: This will return when we stabilize push notifications again
        //
        //var footerDescription: String?
        //
        //if User.current == nil {
        //    footerDescription = "To enable notifications, you need to configure your iCloud account on iOS"
        //}
        //else if self.appDelegate?.authorizedNotification == false {
        //    footerDescription = "You need to authorize Notifications for Evolution App before the switch be enabled. Settings > Notifications > Evolution > Allow Notifications."
        //}
        //
        // let notifications = Section(
        //     section: .notifications,
        //     items: [
        //         Subscription(text: "Proposal creation/update", type: .undefined, value: "", subscribed: false)],
        //     footer: footerDescription,
        //     grouped: false
        // )

        let author = Section(
            section: .author,
            items: [
                Contributor(
                    text: "Thiago Holanda",
                    type: .github,
                    value: "unnamedd"
                )
            ],
            footer: nil,
            grouped: false
        )
        
        let about = Section(
            section: .about,
            items: [
                Item(
                    text: "See all details about this app",
                    type: .undefined,
                    value: ""
                )
            ],
            footer: nil,
            grouped: false
        )
        
        
        dataSource = [
            // notifications,
            author,
            about
        ]
    }
}

// MARK: - UITableView DataSource
extension SettingsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
            
        let section = dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        
        if section.section == .notifications {
            let switchCell = tableView.cell(forRowAt: indexPath) as SwitchTableViewCell
            
            switchCell.descriptionLabel?.text = item.text
            switchCell.indexPath = indexPath
            switchCell.delegate = self

            let enabled = User.current != nil && appDelegate?.authorizedNotification == true
            switchCell.activeSwitch.isEnabled = enabled
            switchCell.activeSwitch.isUserInteractionEnabled = enabled
            
            cell = switchCell
        }
        else if section.section == .about {
            cell = tableView.cell(forRowAt: indexPath) as CustomSubtitleTableViewCell
            cell.textLabel?.text        = "Contributors, licenses and more"
            cell.detailTextLabel?.text  = item.text
        }
        else if section.section == .author, let contributor = section.items.first as? Contributor {
            let contributorCell = tableView.cell(forRowAt: indexPath) as CustomSubtitleTableViewCell
            contributorCell.contributor = contributor
            cell = contributorCell
        }
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension SettingsTableViewController {

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setNeedsDisplay()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = dataSource[section]
        
        return section.section.description
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = dataSource[section]
        
        return section.footer
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource[indexPath.section]
        if section.section == .author {
            return 60
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource[indexPath.section]
        
        if section.section == .about {
            performSegue(withIdentifier: "AboutStoryboardSegue", sender: nil)
        }
        else if section.section == .author, let item = section.items.first {
            let alertController = UIAlertController.presentAlert(to: item)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableView Delegate
extension SettingsTableViewController: SwitchTableViewCellProtocol {
    func `switch`(active: Bool, didChangeSelectionAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard appDelegate.authorizedNotification else {
            appDelegate.registerForPushNotification()
            updateNotification(loading: true)

            return
        }
        
        updateSettings(to: User.current)
    }
}

// MARK: - Network
extension SettingsTableViewController {
    private func getDetails(from user: User?) {
        guard let user = user else {
            return
        }

        DispatchQueue.main.async {
            self.updateNotification(loading: true)
        }
        
        NotificationsService.getDetails(from: user) { [weak self] result in
            guard let user = result.value else {
                if let error = result.error {
                    print("Error: \(error)")
                }
                return
            }
            
            self?.updateNotificationData(to: user)
            
            DispatchQueue.main.async {
                self?.updateNotification(loading: false)
                self?.updateNotification(useDataSource: true)
            }
        }
    }
    
    private func updateSettings(to user: User?) {
        guard var user = user else {
            return
        }
        
        guard let indexPath = indexPathForNotifications() else {
            return
        }

        guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else {
            return
        }
        
        DispatchQueue.main.async {
            self.updateNotification(loading: true)
        }
        
        user.notifications = cell.activeSwitch.isOn
        NotificationsService.updateTags(to: user) { [weak self] result in
            guard let user = result.value else {
                if let error = result.error {
                    print("Error: \(error)")
                }
                return
            }
            
            self?.updateNotificationData(to: user)
            
            DispatchQueue.main.async {
                self?.updateNotification(loading: false)
                self?.updateNotification(useDataSource: true)
            }
        }
    }
}

// MARK: - Notification Center
extension SettingsTableViewController {
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNotification(_:)),
                                               name: NSNotification.Name.NotificationRegister,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNotification(_:)),
                                               name: NSNotification.Name.AppDidBecomeActive,
                                               object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(NSNotification.Name.NotificationRegister)
        NotificationCenter.default.removeObserver(NSNotification.Name.AppDidBecomeActive)
    }
    
    @objc
    private func didReceiveNotification(_ notification: Notification) {
        if notification.name == NSNotification.Name.NotificationRegister {
            getDetails(from: User.current)
        }
        else if notification.name == NSNotification.Name.AppDidBecomeActive {
            buildDataSource()
            tableView.reloadData()
        }
    }
}

// MARK: - Mutation
extension SettingsTableViewController {
    private func indexPathForNotifications() -> IndexPath? {
        var indexPath: IndexPath?
        
        for (s, section) in dataSource.enumerated() {
            guard section.section == .notifications else {
                continue
            }
            
            for (i, item) in section.items.enumerated() {
                guard item is Subscription else {
                    continue
                }
                
                indexPath = IndexPath(row: i, section: s)
            }
        }
        
        return indexPath
    }
    
    private func updateNotification(loading: Bool? = nil) {
        guard let indexPath = indexPathForNotifications() else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else {
            return
        }
        
        if let loading = loading {
            DispatchQueue.main.async {
                cell.loadingActivity = loading
            }
        }
        
    }
    
    private func updateNotification(useDataSource: Bool) {
        guard let indexPath = indexPathForNotifications() else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else {
            return
        }

        if let item = dataSource[indexPath.section].items[indexPath.row] as? Subscription, useDataSource {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                cell.activeSwitch.setOn(item.subscribed, animated: true)
            }
        }
    }
    
    private func updateNotificationData(to user: User) {
        guard let indexPath = indexPathForNotifications() else {
            return
        }
        
        var source = dataSource
        var section = source[indexPath.section]
        
        if var item = section.items[indexPath.row] as? Subscription, let tags = user.tags {
            item.subscribed = tags.count > 0
            section.items[indexPath.row] = item
        }
        
        source[indexPath.section] = section
        
        dataSource = source
    }
}

// MARK: - DescriptionView Delegate
extension SettingsTableViewController: DescriptionViewProtocol {
    func closeAction() {
        dismiss(animated: true)
    }
}
