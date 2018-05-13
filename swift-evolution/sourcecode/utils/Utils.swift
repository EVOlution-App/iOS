import UIKit

struct Config {
    
    struct Date {
        struct Formatter {
            static func custom(_ value: String) -> DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = value
                formatter.locale = Locale(identifier: "en_US")
                
                return formatter
            }
            
            static var iso8601: DateFormatter {
                return custom("yyyy-MM-dd'T'HH:mm:ss.SSS")
            }
            
            static var yearMonthDay: DateFormatter {
                return custom("yyyy-MM-dd")
            }

            static var monthDay: DateFormatter {
                return custom("MMMM dd")
            }
        }
    }
    
    enum Segues: String, SegueRepresentable {
        case proposalDetail = "ProposalDetailSegue"
        case profile = "ProfileSegue"
        case aboutDetails = "AboutDetailsItemsSegue"
    }
    
    struct Nib {
        static func loadNib(name: String?) -> UINib? {
            guard let name = name else {
                return nil
            }
            
            let bundle = Bundle.main
            let nib = UINib(nibName: name, bundle: bundle)
            
            return nib
        }
    }
    
    struct Common {
        struct Regex {
            static var proposalID: String {
                return "SE-([0-9]+)"
            }
            
            static var bugID: String {
                return "SR-([0-9]+)"
            }
        }
    }
    
    struct Orientation {
        /**
         Force the screen back to portrait orientation
         */
        static func portrait() {
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let value = !isPad
                ? UIInterfaceOrientation.portrait.rawValue
                : UIDevice.current.orientation.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    struct Base {
        struct URL {
            struct Evolution {
                static var base: String {
                    return "https://data.evoapp.io"
                }
                
                static var proposals: String {
                    return "\(base)/proposals"
                }
                
                static func markdown(for id: String) -> String {
                    return "\(base)/proposal/\(id)/markdown"
                }
            }
            
            struct GitHub {
                static var users: String {
                    return "https://api.github.com/users"
                }
                
                static var base: String {
                    return "https://github.com"
                }
            }
            
            struct Notifications {
                static var base: String {
                    guard
                        let settings = Environment.settings,
                        let key = settings["NotificationURL"] as? String,
                        key != "" else {
                            fatalError("Notification URL should be defined on Info.plist")
                    }
                    
                    return key
                }
                
                static var add: String {
                    return "\(base)/device"
                }
                
                static var track: String {
                    return "\(base)/track"
                }
                
                static func user(id: String) -> String {
                    return "\(base)/user/\(id)"
                }
                
                static var tags: String {
                    return "\(base)/tags"
                }
            }
        }
    }
}

extension NSNotification.Name {
    static let URLScheme = NSNotification.Name(rawValue: "URLSchemeActivation")
}
