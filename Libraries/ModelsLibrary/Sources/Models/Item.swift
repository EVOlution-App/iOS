import Foundation

// MARK: - Items

public struct Contributor: ItemProtocol {
  public var text: String
  public var type: ItemType
  public var value: String

  public init(text: String, type: ItemType, value: String = "") {
    self.text = text
    self.type = type
    self.value = value
  }
}

public struct License: ItemProtocol {
  public var text: String
  public var type: ItemType
  public var value: String

  public init(text: String, type: ItemType, value: String = "") {
    self.text = text
    self.type = type
    self.value = value
  }
}

public struct Item: ItemProtocol {
  public var text: String
  public var type: ItemType
  public var value: String

  public init(text: String, type: ItemType, value: String = "") {
    self.text = text
    self.type = type
    self.value = value
  }
}

public struct Subscription: ItemProtocol {
  public var text: String
  public var type: ItemType
  public var value: String
  public var subscribed: Bool

  public init(text: String, type: ItemType, value: String, subscribed: Bool) {
    self.text = text
    self.type = type
    self.value = value
    self.subscribed = subscribed
  }
}

// MARK: - ItemType

public enum ItemType: String {
  case github = "github.com"
  case twitter = "twitter.com"
  case url
  case email
  case undefined
}
