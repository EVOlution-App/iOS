enum Section: String {
    case mainDeveloper = "Main Developer"
    case contributors = "Contributors"
    case licenses = "Licenses"
    case evolution = "Evolution App"
    case swiftEvolution = "Swift Evolution"
    case thanks = "Thanks to"
}

// MARK: -
enum Type: String {
    case github = "github.com"
    case twitter = "twitter.com"
    case url
    case email
}

// MARK: - ItemProtocols
protocol ItemProtocol {
    var text: String { get set }
    var type: Type { get  set }
    var value: String { get set }
}

struct Contributor: ItemProtocol {
    var text: String
    var type: Type
    var value: String
}

struct License: ItemProtocol {
    var text: String
    var type: Type
    var value: String
}

struct Item: ItemProtocol {
    var text: String
    var type: Type
    var value: String
}

// MARK: -
struct About {
    let section: Section
    let items: [ItemProtocol]
    let footer: String?
    let grouped: Bool
}
