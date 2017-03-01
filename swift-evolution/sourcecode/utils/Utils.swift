import UIKit

struct Config {
    
    struct Date {
        struct Formatter {
            static var internals: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                
                return formatter
            }
            
            static var externals: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd 'de' MMMM 'de' YYYY - 'às' HH'h'mm"
                formatter.locale = Locale(identifier: "pt_BR")
                
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
