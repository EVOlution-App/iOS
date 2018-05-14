import UIKit

final class CustomSubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var contributor: Contributor? {
        didSet {
            guard let contributor = contributor else {
                return
            }
            
            let placeholder = UIImage(named: "placeholder-photo")
            imageView?.image = placeholder
            
            textLabel?.text = contributor.text
            detailTextLabel?.text = contributor.media
            
            loadProfileImage()
        }
    }
    
    var license: License? {
        didSet {
            guard let license = license else {
                return
            }
            
            textLabel?.text = license.text
            detailTextLabel?.text = license.media
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let imageView = imageView {
            let currentSize = imageView.frame.size
            let size = CGSize(width: currentSize.width - 4, height: currentSize.height - 4)
            
            let currentOrigin = imageView.frame.origin
            let origin = CGPoint(x: currentOrigin.x + 2, y: currentOrigin.y + 2)
            
            let frame = CGRect(origin: origin, size: size)
            imageView.frame = frame
            
            imageView.backgroundColor = UIColor.Proposal.lightGray.withAlphaComponent(0.5)
            imageView.round(with: UIColor.clear, width: 0)
        }
    }
    
    private func loadProfileImage() {
        guard let contributor = contributor, let imageView = imageView else {
            return
        }
        
        let url = contributor.picture(120)
        guard url != "" else {
            return
        }
        
        imageView.loadImage(from: url)
    }
}
