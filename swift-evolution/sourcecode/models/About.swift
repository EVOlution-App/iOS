
enum Section: String {
    case mainDeveloper = "Main Developer"
    case contributors = "Contributors"
    case licenses = "Licenses"
    case evolution = "Evolution App"
    case swiftEvolution = "Swift Evolution"
    case thanks = "Thanks to"
}

// MARK: - Section Extension
extension Section: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}

// MARK: -
enum Type: String {
    case github = "github.com"
    case twitter = "twitter.com"
    case url
    case email
}

// MARK: -
typealias Contributor = Item
typealias License = Item
struct Item {
    let text: String
    let type: Type
    let value: String
}

// MARK: -
struct About {
    let section: Section
    let items: [Item]
    let footer: String?
    let grouped: Bool
}
