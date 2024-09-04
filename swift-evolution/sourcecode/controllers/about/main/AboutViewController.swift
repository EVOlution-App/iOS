import StoreKit
import UIKit

final class AboutViewController: UITableViewController {
  // MARK: - Private properties
    
  private lazy var dataSource: [Section] = sectionsData()
    
  // MARK: - IBOutlets
    
  @IBOutlet private var versionLabel: UILabel!
  @IBOutlet private var closeButton: UIButton?
    
  override func viewDidLoad() {
    super.viewDidLoad()
        
    tableView.register(CustomSubtitleTableViewCell.self, forCellReuseIdentifier: "AboutCellIdentifier")
    tableView.reloadData()
        
    // Ask for review
    DispatchQueue.global(qos: .background).async {
      SKStoreReviewController.requestReview()
    }
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
    
  private func sectionsData() -> [Section] {
    [
      mainDeveloper(),
      contributors(),
      licenses(),
      app(),
      swiftEvolution(),
      thanks(),
    ]
  }
    
  private func mainDeveloper() -> Section {
    Section(
      section: .mainDeveloper,
      items: [
        Contributor(
          text: "Thiago Holanda",
          type: .github,
          value: "unnamedd"
        ),
      ],
      footer: nil,
      grouped: false
    )
  }
    
  private func contributors() -> Section {
    let members = [
      Contributor(text: "Anton Kuzmin", type: .github, value: "uuttff8"),
      Contributor(text: "Bruno Bilescky", type: .github, value: "brunogb"),
      Contributor(text: "Bruno Guidolim", type: .github, value: "bguidolim"),
      Contributor(text: "Bruno Hecktheuer", type: .github, value: "bbheck"),
      Contributor(text: "Diego Ventura", type: .github, value: "diegoventura"),
      Contributor(text: "Diogo Tridapalli", type: .github, value: "diogot"),
      Contributor(text: "Ezequiel França", type: .github, value: "ezefranca"),
      Contributor(text: "Gustavo Barbosa", type: .github, value: "barbosa"),
      Contributor(text: "Guilherme Rambo", type: .github, value: "insidegui"),
      Contributor(text: "Leonardo Cardoso", type: .github, value: "leonardocardoso"),
      Contributor(text: "Ricardo Borelli", type: .github, value: "rabc"),
      Contributor(text: "Ricardo Olivieri", type: .github, value: "rolivieri"),
      Contributor(text: "Rob Hudson", type: .github, value: "robtimp"),
      Contributor(text: "Rodrigo Reis", type: .github, value: "digoreis"),
      Contributor(text: "Taylor Franklin", type: .github, value: "tfrank64"),
      Contributor(text: "Xaver Lohmüller", type: .github, value: "xaverlohmueller"),
    ]
        
    return Section(
      section: .contributors,
      items: members,
      footer: nil,
      grouped: true
    )
  }
    
  private func licenses() -> Section {
    let items = [
      License(text: "MarkdownSyntax", type: .github, value: "hebertialmeida/MarkdownSyntax"),
      License(text: "Reachability.swift", type: .github, value: "ashleymills/Reachability.swift"),
      License(text: "SwiftRichString", type: .github, value: "malcommac/SwiftRichString"),
      License(text: "KeychainAccess", type: .github, value: "kishikawakatsumi/KeychainAccess"),
    ]
        
    return Section(
      section: .licenses,
      items: items,
      footer: nil,
      grouped: true
    )
  }
    
  private func app() -> Section {
    let items = [
      Item(text: "iOS App", type: .github, value: "evolution-app/ios"),
      Item(text: "Backend", type: .github, value: "evolution-app/backend"),
      Item(text: "Twitter", type: .twitter, value: "evoapp_io"),
      Item(text: "Feedback", type: .email, value: "feedback@evoapp.io"),
    ]
        
    return Section(
      section: .evolution,
      items: items,
      footer: nil,
      grouped: false
    )
  }
    
  private func swiftEvolution() -> Section {
    let items = [
      Item(text: "Swift Language - Twitter", type: .twitter, value: "swiftlang"),
      Item(text: "Site", type: .url, value: "https://apple.github.io/swift-evolution"),
      Item(text: "Repository", type: .github, value: "apple/swift-evolution"),
      Item(text: "Forum", type: .url, value: "https://forums.swift.org/c/evolution"),
    ]
        
    return Section(
      section: .swiftEvolution,
      items: items,
      footer: nil,
      grouped: false
    )
  }
    
  private func thanks() -> Section {
    let items = [
      Item(text: "Chris Bailey", type: .twitter, value: "Chris__Bailey"),
      Item(text: "Daniel Dunbar", type: .twitter, value: "daniel_dunbar"),
      Item(text: "Danilo Altheman", type: .twitter, value: "daltheman"),
      Item(text: "John Calistro", type: .twitter, value: "johncalistro"),
      Item(text: "Lisa Dziuba", type: .twitter, value: "LisaDziuba"),
    ]
        
    let copyright =
      "Copyright (c) 2017-2024 Thiago Holanda (thiago@evoapp.io)\n\nSwift and the Swift logo are trademarks of Apple Inc., registered in the U.S. and other countries."
    return Section(
      section: .thanks,
      items: items,
      footer: copyright,
      grouped: false
    )
  }
}

// MARK: - Navigation

extension AboutViewController {
  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    if let destinationViewController = segue.destination as? AboutDetailTableViewController,
       let indexPath = tableView.indexPathForSelectedRow
    {
      let section = dataSource[indexPath.section]
      if section.grouped {
        destinationViewController.about = section
      }
    }
  }
}

// MARK: - UITableView Data Source

extension AboutViewController {
  override func numberOfSections(in _: UITableView) -> Int {
    dataSource.count
  }
    
  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    let about = dataSource[section]
    guard about.grouped == false else {
      return 1
    }
        
    return about.items.count
  }
    
  override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    let about = dataSource[section]
        
    return about.section.description
  }
    
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let about = dataSource[indexPath.section]
    let item = about.items[indexPath.row]
        
    let cellIdentifier = about.grouped ? "GroupedTableViewCell" : "AboutCellIdentifier"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                             for: indexPath)
        
    cell.selectionStyle = .none
        
    if about.grouped {
      let contributors = about.items.shuffle()
      cell.textLabel?.text = contributors.text
    }
    else {
      cell.textLabel?.text = item.text
      cell.detailTextLabel?.text = item.media
    }
        
    return cell
  }
    
  override func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
    guard let footer = dataSource[section].footer else {
      return nil
    }
        
    return footer
  }
}

// MARK: - UITableView Delegate

extension AboutViewController {
  override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    let about = dataSource[indexPath.section]
    let item = about.items[indexPath.row]
        
    if about.grouped {
      Config.Segues.aboutDetails.performSegue(in: self)
    }
    else {
      let alertController = UIAlertController.presentAlert(to: item)
      present(alertController, animated: true, completion: nil)
    }
  }
}
