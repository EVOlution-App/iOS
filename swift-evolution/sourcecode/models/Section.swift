enum SectionType: String {
  // About
  case mainDeveloper = "Main Developer"
  case contributors = "Contributors"
  case licenses = "Licenses"
  case evolution = "Evolution App"
  case swiftEvolution = "Swift Evolution"
  case thanks = "Thanks to"

  // Settings
  case app
  case notifications = "Notifications"
  case about = "Open Source"
  case author = "Author"
}

// MARK: -

struct Section {
  var section: SectionType
  var items: [ItemProtocol] = []
  var footer: String?
  var grouped: Bool = false
}
