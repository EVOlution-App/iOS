import UIKit

final class CustomSubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        imageView?.backgroundColor = UIColor.Proposal.lightGray.withAlphaComponent(0.5)
        imageView?.round(with: UIColor.clear, width: 0)
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
