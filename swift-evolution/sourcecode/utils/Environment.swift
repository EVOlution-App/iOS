import Foundation

enum Environment {
  static var settings: [String: Any]? {
    guard
      let dict = Bundle.main.infoDictionary,
      let settings = dict["EnvironmentSettings"] as? [String: Any]
    else {
      return nil
    }

    return settings
  }

  static var title: String? {
    guard
      let settings,
      let title = settings["Title"] as? String
    else {
      return nil
    }

    return title
  }

  static var bundleIdentifier: String? {
    guard
      let dict = Bundle.main.infoDictionary,
      let identifier = dict["CFBundleIdentifier"] as? String
    else {
      return nil
    }

    return identifier
  }

  enum Keys {
    static var notification: String? {
      guard
        let settings = Environment.settings,
        let key = settings["Notification"] as? String,
        key != ""
      else {
        return nil
      }

      return key
    }
  }

  enum Release {
    static var name: String? {
      guard
        let dict = Bundle.main.infoDictionary,
        let name = dict["CFBundleDisplayName"] as? String
      else {
        return nil
      }

      return name
    }

    static var version: String? {
      guard
        let dict = Bundle.main.infoDictionary,
        let name = dict["CFBundleShortVersionString"] as? String
      else {
        return nil
      }

      return name
    }

    static var build: String? {
      guard
        let dict = Bundle.main.infoDictionary,
        let name = dict["CFBundleVersion"] as? String
      else {
        return nil
      }

      return name
    }
  }
}
