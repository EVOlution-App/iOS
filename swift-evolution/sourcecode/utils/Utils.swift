import UIKit

struct Config {
    
    struct Date {
        struct Formatter {
            static var iso8601: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                
                return formatter
            }
            
            static var yearMonthDay: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                return formatter
            }

            static var monthDay: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM dd"

                return formatter
            }
        }
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
}
