import UIKit

extension UIImageView {
    public func round(with color: UIColor? = nil, width: CGFloat?) {
        
        if let color = color {
            self.layer.borderColor = color.cgColor
        }
        
        if let width = width {
            self.layer.borderWidth = width
        }
        
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.masksToBounds = true
    }
    
    public func loadImage(from url: String?) {
        guard let url = url, url.isEmpty == false else {
            return
        }
        
        Service.requestImage(url) { [weak self] result in
            
            guard let image = result.value else {
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
