enum Section: String {
    case mainDeveloper = "Main Developer"
    case backend = "Backend"
    case contributors = "Contributors"
    case licenses = "Licenses"
    case contacts = "Contacts"
    case sourceCode = "Source code"
    case cloudtools = "Cloud Tools"
    case moreData = "More Data"
    case thanks = "Thanks to"
}

enum Type: String {
    case github = "github.com"
    case twitter = "twitter.com"
    case url
    case email
}

struct Item {
    let text: String
    let type: Type
    let value: String
}

struct About {
    let section: Section
    let items: [Item]
    let footer: String?
}
