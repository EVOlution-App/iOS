import Foundation
import UserNotifications

import ModelsLibrary

extension UNNotificationResponse {
  func customContent() -> Notifications.CustomContent? {
    guard let custom = notification.request.content.userInfo["custom"] as? [String: Any] else {
      return nil
    }

    guard let value = custom["a"] as? [String: Any] else {
      return nil
    }

    do {
      let decoder = JSONDecoder()
      let data = try JSONSerialization.data(withJSONObject: value, options: [])

      return try decoder.decode(Notifications.CustomContent.self, from: data)
    }
    catch {
      print("Error: \(error.localizedDescription)")

      return nil
    }
  }

  func deeplink() throws -> URL {
    guard let custom = customContent() else {
      throw "Custom content is nil"
    }

    guard let url = URL(string: "evo://\(custom.type.rawValue)/\(custom.value)") else {
      throw "Invalid deeplinking URL"
    }

    return url
  }
}
