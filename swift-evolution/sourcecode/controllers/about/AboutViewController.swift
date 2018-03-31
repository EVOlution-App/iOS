import UIKit
import Crashlytics
import StoreKit

class AboutViewController: UITableViewController {

    fileprivate var dataSource: [About] = []
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet var closeButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton?.isHidden = UIDevice.current.userInterfaceIdiom != .pad

        if let version = Environment.Release.version,
            let build = Environment.Release.build {
            
            self.versionLabel.text = "v\(version) (\(build))"
        }
        
        self.buildAboutData()
        self.tableView.reloadData()
        
        Answers.logContentView(withName: "About this app",
                               contentType: "Load View",
                               contentId: nil,
                               customAttributes: nil)
        
        // Ask for review
        SKStoreReviewController.requestReview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }

    func buildAboutData() {
        var about: [About] = []
        
        // Main Developer
        let thiago = Item(text: "Thiago Holanda", type: .github, value: "unnamedd")
        let mainDeveloper = About(section: .mainDeveloper, items: [thiago], footer: nil)
        about.append(mainDeveloper)

        // Contributors
        let bilescky    = Item(text: "Bruno Bilescky", type: .github, value: "brunogb")
        let guidolim    = Item(text: "Bruno Guidolim", type: .github, value: "bguidolim")
        let hecktheuer  = Item(text: "Bruno Hecktheuer", type: .github, value: "bbheck")
        let ventura     = Item(text: "Diego Ventura", type: .github, value: "diegoventura")
        let tridapalli  = Item(text: "Diogo Tridapalli", type: .github, value: "diogot")
        let ezeq        = Item(text: "Ezequiel França", type: .twitter, value: "ezefranca")
        let gustavo     = Item(text: "Gustavo Barbosa", type: .github, value: "barbosa")
        let rambo       = Item(text: "Guilherme Rambo", type: .github, value: "insidegui")
        let leocardoso  = Item(text: "Leonardo Cardoso", type: .github, value: "leonardocardoso")
        let borelli     = Item(text: "Ricardo Borelli", type: .github, value: "rabc")
        let ricardo     = Item(text: "Ricardo Olivieri", type: .github, value: "rolivieri")
        let hudson      = Item(text: "Rob Hudson", type: .github, value: "robtimp")
        let reis        = Item(text: "Rodrigo Reis", type: .github, value: "digoreis")
        let taylor      = Item(text: "Taylor Franklin", type: .github, value: "tfrank64")
        let xaver       = Item(text: "Xaver Lohmüller", type: .github, value: "xaverlohmueller")
        
        let contributors = About(section: .contributors, items: [bilescky, guidolim, hecktheuer, ventura, tridapalli, ezeq, gustavo, rambo, leocardoso, borelli, ricardo, hudson, reis, taylor, xaver], footer: nil)
        about.append(contributors)
        
        // Licenses
        let down            = Item(text: "Down", type: .github, value: "iwasrobbed/Down")
        let reachability    = Item(text: "Reachability.swift", type: .github, value: "ashleymills/Reachability.swift")
        let svprogresshud   = Item(text: "SVProgressHUD", type: .github, value: "SVProgressHUD/SVProgressHUD")
        let swiftrichstring = Item(text: "SwiftRichString", type: .github, value: "malcommac/SwiftRichString")
        
        let licenses = About(section: .licenses, items: [down, reachability, svprogresshud, swiftrichstring], footer: nil)
        about.append(licenses)
        
        // Cloud Tools
        let bluemix = Item(text: "IBM Cloud", type: .url, value: "https://ibm.cloud")
        let kitura = Item(text: "Kitura Web Framework", type: .url, value: "http://www.kitura.io/")
        
        let cloudTools = About(section: .cloudtools, items: [bluemix, kitura], footer: nil)
        about.append(cloudTools)
        
        // Source code repositories
        let app = Item(text: "iOS App", type: .github, value: "evolution-app/ios")
        let backend = Item(text: "Backend", type: .github, value: "evolution-app/backend")
        
        let repositories = About(section: .sourceCode, items: [app, backend], footer: nil)
        about.append(repositories)
        
        // Contacts
        let swiftlang   = Item(text: "Swift Language - Twitter", type: .twitter, value: "swiftlang")
        let twitterApp  = Item(text: "App - Twitter", type: .twitter, value: "evoapp_io")
        let feedbackApp = Item(text: "App - Feedback", type: .email, value: "feedback@evoapp.io")
        
        let feedback = "If you have any criticals, suggestions or want to contribute any way, please, get in touch with us."
        let contacts = About(section: .contacts, items: [swiftlang, twitterApp, feedbackApp], footer: feedback)
        about.append(contacts)
        
        // More Data
        let web         = Item(text: "Web", type: .url, value: "https://apple.github.io/swift-evolution")
        let proposals   = Item(text: "Proposals Repo", type: .github, value: "apple/swift-evolution")
        let forum       = Item(text: "Swift Evolution Forum", type: .url, value: "https://forums.swift.org/c/evolution")
        
        let more = About(section: .moreData, items: [web, proposals, forum], footer: nil)
        about.append(more)
        
        // Thanks To
        let chris   = Item(text: "Chris Bailey", type: .twitter, value: "Chris__Bailey")
        let daniel  = Item(text: "Daniel Dunbar", type: .twitter, value: "daniel_dunbar")
        let danilo  = Item(text: "Danilo Altheman", type: .twitter, value: "daltheman")
        let john    = Item(text: "John Calistro", type: .twitter, value: "johncalistro")
        let lisa    = Item(text: "Lisa Dziuba", type: .twitter, value: "LisaDziuba")
        
        let copyright = "Copyright (c) 2017-2018 Thiago Holanda (thiago@evoapp.io)\n\nSwift and the Swift logo are trademarks of Apple Inc., registered in the U.S. and other countries."
        let thanks = About(section: .thanks, items: [chris, daniel, danilo, john, lisa], footer: copyright)
        about.append(thanks)
        
        self.dataSource = about
    }
}

extension AboutViewController {
    
    // MARK: - UITableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let about = self.dataSource[section]
        
        return about.items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let about = self.dataSource[section]

        return about.section.rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AboutCellIdentifier"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = self.dataSource[indexPath.section].items[indexPath.row]

        var value = ""
        switch item.type {
        case .github, .twitter:
            value = "\(item.type.rawValue)/\(item.value)"
        default:
            value = item.value
        }
        
        cell.textLabel?.text = item.text
        cell.detailTextLabel?.text = value
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let footer = self.dataSource[section].footer else {
            return nil
        }
        
        return footer
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.section].items[indexPath.row]
        
        var title = "Open Safari?"
        var value = ""
        var message = ""
        
        switch item.type {
        case .twitter:
            value = "twitter://user?screen_name=\(item.value)"
            
            if let url = URL(string: value), UIApplication.shared.canOpenURL(url) {
                title = "Open Twitter ?"
                message = "@\(item.value)"
            }
            else {
                value = "https://\(item.type.rawValue)/\(item.value)"
                message = value
            }
            
        case .github:
            value = "https://\(item.type.rawValue)/\(item.value)"
            message = value
            
        case .email:
            title = "Open Mail ?"
            value = "mailto:\(item.value)"
            message = item.value
            
        default:
            value = item.value
            message = value
        }

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open", style: .default) { [unowned self] _ in
            let about = self.dataSource[indexPath.row]
            
            if let url = URL(string: value) {
                UIApplication.shared.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: false]) { _ in
                    Answers.logCustomEvent(withName: message, customAttributes: ["type": item.type.rawValue, "section": about.section.rawValue])
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
