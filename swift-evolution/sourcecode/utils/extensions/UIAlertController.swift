import UIKit

extension UIAlertController {
    static func presentAlert(to item: ItemProtocol) -> UIAlertController {
        var title = "Open Safari?"
        var value = ""
        var message = ""
        
        switch item.type {
        case .twitter:
            value = "twitter://user?screen_name=\(item.value)"
            
            if let url = URL(string: value), UIApplication.shared.canOpenURL(url) {
                title = "Open Twitter ?"
                message = "@\(item.value)"
            }
            else {
                value = "https://\(item.type.rawValue)/\(item.value)"
                message = value
            }
            
        case .github:
            value = "https://\(item.type.rawValue)/\(item.value)"
            message = value
            
        case .email:
            title = "Open Mail ?"
            value = "mailto:\(item.value)"
            message = item.value
            
        default:
            value = item.value
            message = value
        }
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open", style: .default) { _ in
            if let url = URL(string: value) {
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false])
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)
        
        return alertController
    }

}
