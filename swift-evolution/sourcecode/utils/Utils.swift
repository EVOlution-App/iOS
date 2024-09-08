import UIKit

enum Config {
  enum Date {
    enum Formatter {
      static func custom(_ value: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = value
        formatter.locale = Locale(identifier: "en_US")

        return formatter
      }

      static var iso8601: DateFormatter {
        custom("yyyy-MM-dd'T'HH:mm:ss.SSS")
      }

      static var yearMonthDay: DateFormatter {
        custom("yyyy-MM-dd")
      }

      static var monthDay: DateFormatter {
        custom("MMMM dd")
      }
    }
  }

  enum Segues: String, SegueRepresentable {
    case proposalDetail = "ProposalDetailSegue"
    case profile = "ProfileSegue"
    case aboutDetails = "AboutDetailsItemsSegue"
  }

  enum Nib {
    static func loadNib(name: String?) -> UINib? {
      guard let name else {
        return nil
      }

      let bundle = Bundle.main
      let nib = UINib(nibName: name, bundle: bundle)

      return nib
    }
  }

  enum Common {
    enum Regex {
      static var proposalIdentifier: String {
        "SE-([0-9]+)"
      }

      static var bugIdentifier: String {
        "SR-([0-9]+)"
      }
    }
  }

  enum Orientation {
    /**
     Force the screen back to portrait orientation
     */
    static func portrait() {
      let isPad = UIDevice.current.userInterfaceIdiom == .pad
      let value = isPad == false
        ? UIInterfaceOrientation.portrait.rawValue
        : UIDevice.current.orientation.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
    }
  }

  enum Base {
    enum URL {
      enum Evolution {
        static var base: String {
          "https://data.evoapp.io"
        }

        static var proposals: String {
          "\(base)/proposals"
        }

        static func markdown(for identifier: String) -> String {
          "\(base)/proposal/\(identifier)/markdown"
        }
      }

      enum GitHub {
        static var users: String {
          "https://api.github.com/users"
        }

        static var base: String {
          "https://github.com"
        }
      }

      enum Notifications {
        static var base: String {
          guard
            let settings = Environment.settings,
            let key = settings["NotificationURL"] as? String,
            key != ""
          else {
            fatalError("Notification URL should be defined on Info.plist")
          }

          return key
        }

        static var add: String {
          "\(base)/device"
        }

        static var track: String {
          "\(base)/track"
        }

        static func user(identifier: String) -> String {
          "\(base)/user/\(identifier)"
        }

        static var tags: String {
          "\(base)/tags"
        }
      }
    }
  }
}

extension Notification.Name {
  static let URLScheme = NSNotification.Name("URLSchemeActivation")
  static let NotificationRegister = Notification.Name("FinishedRegisterNotification")
  static let AppDidBecomeActive = Notification.Name("AppDidBecomeActive")
}
