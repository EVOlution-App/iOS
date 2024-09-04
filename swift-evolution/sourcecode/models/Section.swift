enum SectionType: String {
    // About
    case mainDeveloper = "Main Developer"
    case contributors = "Contributors"
    case licenses = "Licenses"
    case evolution = "Evolution App"
    case swiftEvolution = "Swift Evolution"
    case thanks = "Thanks to"

    // Settings
    case notifications = "Notifications"
    case about = "Open Source"
    case author = "Author"
}

// MARK: -

enum Type: String {
    case github = "github.com"
    case twitter = "twitter.com"
    case url
    case email
    case undefined
}

// MARK: - ItemProtocols

protocol ItemProtocol {
    var text: String { get set }
    var type: Type { get set }
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

struct Subscription: ItemProtocol {
    var text: String
    var type: Type
    var value: String
    var subscribed: Bool
}

// MARK: -

struct Section {
    var section: SectionType
    var items: [ItemProtocol]
    var footer: String?
    var grouped: Bool
}
