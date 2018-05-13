import UIKit
import Crashlytics
import StoreKit

final class AboutViewController: UITableViewController {

    // MARK: - Private properties
    private lazy var dataSource: [Section] = {
        return sectionsData()
    }()
    
    // MARK: - IBOutlets
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet private var closeButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CustomSubtitleTableViewCell.self, forCellReuseIdentifier: "AboutCellIdentifier")
        tableView.reloadData()
        
        Answers.logContentView(withName: "About this app",
                               contentType: "Load View",
                               contentId: nil,
                               customAttributes: nil)
        
        // Ask for review
        DispatchQueue.global(qos: .background).async {
            SKStoreReviewController.requestReview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func sectionsData() -> [Section] {
        var about: [Section] = []
        
        // Main Developer
        let thiago = Contributor(text: "Thiago Holanda", type: .github, value: "unnamedd")
        let mainDeveloper = Section(section: .mainDeveloper, items: [thiago], footer: nil, grouped: false)
        about.append(mainDeveloper)

        // Contributors
        let contributorsMembers = [
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
            Contributor(text: "Xaver Lohmüller", type: .github, value: "xaverlohmueller")
        ]
        
        let contributors = Section(section: .contributors, items: contributorsMembers, footer: nil, grouped: true)
        about.append(contributors)
        
        // Licenses
        let licensesItems = [
            License(text: "Down", type: .github, value: "iwasrobbed/Down"),
            License(text: "Reachability.swift", type: .github, value: "ashleymills/Reachability.swift"),
            License(text: "SVProgressHUD", type: .github, value: "SVProgressHUD/SVProgressHUD"),
            License(text: "SwiftRichString", type: .github, value: "malcommac/SwiftRichString"),
            License(text: "KeychainAccess", type: .github, value: "kishikawakatsumi/KeychainAccess"),
            License(text: "Kitura Web Framework", type: .url, value: "http://www.kitura.io/")
        ]
        
        let licenses = Section(section: .licenses, items: licensesItems, footer: nil, grouped: true)
        about.append(licenses)
        
        // Evolution App
        let app         = Item(text: "iOS App", type: .github, value: "evolution-app/ios")
        let backend     = Item(text: "Backend", type: .github, value: "evolution-app/backend")
        let twitterApp  = Item(text: "Twitter", type: .twitter, value: "evoapp_io")
        let feedbackApp = Item(text: "Feedback", type: .email, value: "feedback@evoapp.io")

        let contacts = Section(section: .evolution, items: [app, backend, twitterApp, feedbackApp], footer: nil, grouped: false)
        about.append(contacts)
        
        // Swift Evolution
        let language    = Item(text: "Swift Language - Twitter", type: .twitter, value: "swiftlang")
        let web         = Item(text: "Site", type: .url, value: "https://apple.github.io/swift-evolution")
        let proposals   = Item(text: "Repository", type: .github, value: "apple/swift-evolution")
        let forum       = Item(text: "Forum", type: .url, value: "https://forums.swift.org/c/evolution")
        
        let more = Section(section: .swiftEvolution, items: [language, web, proposals, forum], footer: nil, grouped: false)
        about.append(more)
        
        // Thanks To
        let chris   = Item(text: "Chris Bailey", type: .twitter, value: "Chris__Bailey")
        let daniel  = Item(text: "Daniel Dunbar", type: .twitter, value: "daniel_dunbar")
        let danilo  = Item(text: "Danilo Altheman", type: .twitter, value: "daltheman")
        let john    = Item(text: "John Calistro", type: .twitter, value: "johncalistro")
        let lisa    = Item(text: "Lisa Dziuba", type: .twitter, value: "LisaDziuba")
        
        let copyright = "Copyright (c) 2017-2018 Thiago Holanda (thiago@evoapp.io)\n\nSwift and the Swift logo are trademarks of Apple Inc., registered in the U.S. and other countries."
        let thanks = Section(section: .thanks, items: [chris, daniel, danilo, john, lisa], footer: copyright, grouped: false)
        about.append(thanks)
        
        return about
    }
}

// MARK: - Navigation
extension AboutViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AboutDetailTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
            let section = dataSource[indexPath.section]
            if section.grouped {
                destinationViewController.about = section
            }
        }
    }
}

// MARK: - UITableView Data Source
extension AboutViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let about = dataSource[section]
        guard about.grouped == false else {
            return 1
        }
        
        return about.items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let about = dataSource[section]

        return about.section.description
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let about = dataSource[indexPath.section]
        let item = about.items[indexPath.row]
        
        let cellIdentifier = about.grouped ? "GroupedTableViewCell" : "AboutCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        
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
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let footer = dataSource[section].footer else {
            return nil
        }
        
        return footer
    }
}


// MARK: - UITableView Delegate
extension AboutViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let about = dataSource[indexPath.section]
        let item = about.items[indexPath.row]
        
        if about.grouped {
            Config.Segues.aboutDetails.performSegue(in: self)
        }
        else {
            let alertController = UIAlertController.presentAlert(to: item)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - DescriptionView Delegate
extension AboutViewController: DescriptionViewProtocol {
    func closeAction() {
        dismiss(animated: true)
    }
}
