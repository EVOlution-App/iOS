import UIKit

struct Config {
    
    struct Date {
        struct Formatter {
            static var iso8601: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                formatter.locale = Locale(identifier: "en_US")
                
                return formatter
            }
            
            static var yearMonthDay: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.locale = Locale(identifier: "en_US")
                
                return formatter
            }

            static var monthDay: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM dd"
                formatter.locale = Locale(identifier: "en_US")

                return formatter
            }
        }
    }
    
    enum Segues: String, SegueRepresentable {
        case proposalDetail = "ProposalDetailSegue"
        case profile = "ProfileSegue"
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
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    struct Base {
        struct URL {
            static var data: String {
                return "https://data.swift-evolution.io"
            }
            
            static var githubUser: String {
                return "https://api.github.com/users"
            }
        }
    }
}

extension NSNotification.Name {
    static let URLScheme = NSNotification.Name(rawValue: "URLSchemeActivation")
}

