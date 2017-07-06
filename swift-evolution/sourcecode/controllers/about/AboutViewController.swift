import UIKit
import Crashlytics

class AboutViewController: UITableViewController {

    
    fileprivate var dataSource: [About] = []
    @IBOutlet private var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func buildAboutData() {
        var about: [About] = []
        
        // Main Developer
        let thiago = Item(text: "Thiago Holanda", type: .github, value: "unnamedd")
        let mainDeveloper = About(section: .mainDeveloper, items: [thiago], footer: nil)
        about.append(mainDeveloper)
        
        // Backend - Contributors
        let ricardo     = Item(text: "Ricardo Olivieri", type: .github, value: "rolivieri")
        let taylor      = Item(text: "Taylor Franklin", type: .github, value: "tfrank64")
        let backend     = About(section: .backend, items: [ricardo, taylor, thiago], footer: nil)
        about.append(backend)

        // iOS - Contributors
        let bilescky    = Item(text: "Bruno Bilescky", type: .github, value: "brunogb")
        let guidolim    = Item(text: "Bruno Guidolim", type: .github, value: "bguidolim")
        let hecktheuer  = Item(text: "Bruno Hecktheuer", type: .github, value: "bbheck")
        let ventura     = Item(text: "Diego Ventura", type: .github, value: "diegoventura")
        let tridapalli  = Item(text: "Diogo Tridapalli", type: .github, value: "diogot")
        let gustavo     = Item(text: "Gustavo Barbosa", type: .github, value: "barbosa")
        let borelli     = Item(text: "Ricardo Borelli", type: .github, value: "rabc")
        let reis        = Item(text: "Rodrigo Reis", type: .github, value: "digoreis")
        
        let contributors = About(section: .contributors, items: [bilescky, guidolim, hecktheuer, ventura, tridapalli, gustavo, borelli, reis], footer: nil)
        about.append(contributors)
        
        // Licenses
        let down            = Item(text: "Down", type: .github, value: "iwasrobbed/Down")
        let reachability    = Item(text: "Reachability.swift", type: .github, value: "ashleymills/Reachability.swift")
        let unbox           = Item(text: "Unbox", type: .github, value: "JohnSundell/Unbox")
        let svprogresshud   = Item(text: "SVProgressHUD", type: .github, value: "SVProgressHUD/SVProgressHUD")
        let swiftrichstring = Item(text: "SwiftRichString", type: .github, value: "malcommac/SwiftRichString")
        
        let licenses = About(section: .licenses, items: [down, reachability, unbox, svprogresshud, swiftrichstring], footer: nil)
        about.append(licenses)
        
        // Contacts
        let swiftlang   = Item(text: "Swift Language - Twitter", type: .twitter, value: "swiftlang")
        let twitterApp  = Item(text: "App - Twitter", type: .twitter, value: "swift_evolution")
        let feedbackApp = Item(text: "App - Feedback", type: .email, value: "feedback@swift-evolution.io")
        
        let feedback = "If you have any criticals, suggestions or want to contribute any way, please, get in touch with us."
        let contacts = About(section: .contacts, items: [swiftlang, twitterApp, feedbackApp], footer: feedback)
        about.append(contacts)
        
        // More Data
        let web         = Item(text: "Web", type: .url, value: "https://apple.github.io/swift-evolution")
        let proposals   = Item(text: "Proposals Repo", type: .github, value: "apple/swift-evolution")
        let mailing     = Item(text: "Mailing list", type: .url, value: "https://lists.swift.org/mailman/listinfo/swift-evolution")
        
        let more = About(section: .moreData, items: [web, proposals, mailing], footer: nil)
        about.append(more)
        
        // Thanks To
        let chris   = Item(text: "Chris Bailey", type: .twitter, value: "Chris__Bailey")
        let daniel  = Item(text: "Daniel Dunbar", type: .twitter, value: "daniel_dunbar")
        let danilo  = Item(text: "Danilo Altheman", type: .twitter, value: "daltheman")
        let ezeq    = Item(text: "Ezequiel França", type: .twitter, value: "ezefranca")
        let john    = Item(text: "John Calistro", type: .twitter, value: "johncalistro")
        let jesse   = Item(text: "Jesse Squires", type: .twitter, value: "jesse_squires")
        let lisa    = Item(text: "Lisa Dziuba", type: .twitter, value: "LisaDziuba")
        
        let copyright = "Copyright (c) 2017 Thiago Holanda (thiago@swift-evolution.io), Bruno Bilescky (bruno@swift-evolution.io)\n\nSwift and the Swift logo are trademarks of Apple Inc., registered in the U.S. and other countries."
        let thanks = About(section: .thanks, items: [chris, daniel, danilo, ezeq, john, jesse, lisa], footer: copyright)
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
        let item = self.dataSource[indexPath.section].items[indexPath.row];
        
        var title = "Open Safari ?"
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
            
            break
            
        case .github:
            value = "https://\(item.type.rawValue)/\(item.value)"
            message = value
            
            break
            
        case .email:
            title = "Open Mail ?"
            value = "mailto:\(item.value)"
            message = item.value
            
            break
            
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
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly : false]) { success in
                        Answers.logCustomEvent(withName: message, customAttributes: ["type": item.type.rawValue, "section": about.section.rawValue])
                    }
                }
                else {
                    Answers.logCustomEvent(withName: message, customAttributes: ["type": item.type.rawValue, "section": about.section.rawValue])
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)
        
        self.present(alertController, animated: false, completion: nil)
    }
}
