public enum SectionType: String {
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

public struct Section {
  public var section: SectionType
  public var items: [ItemProtocol] = []
  public var footer: String?
  public var grouped: Bool

  public init(section: SectionType, items: [ItemProtocol] = [], footer: String? = nil, grouped: Bool = false) {
    self.section = section
    self.items = items
    self.footer = footer
    self.grouped = grouped
  }
}
