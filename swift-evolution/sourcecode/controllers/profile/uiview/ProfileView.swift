import UIKit
import SwiftRichString

class ProfileView: UIView {

    // IBOutlets
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var statisticsLabel: UILabel!
    
    // MARK: - Public properties
    open var profile: Person? {
        didSet {
            self.configureElements()
        }
    }
    
    open var imageURL: String? {
        didSet {
            self.loadProfileImage()
        }
    }
    
    // MARK: - Life cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.profileImageView.round(with: UIColor.clear, width: 0)
        self.profileImageView.backgroundColor = UIColor.Proposal.lightGray.withAlphaComponent(0.5)
    }
 
    func configureElements() {
        guard let profile = self.profile else {
            return
        }
        
        let details = NSMutableAttributedString()
        details.append(self.render(name: profile.name))
        details.append(self.render(link: profile.link))
        
        let statistics = NSMutableAttributedString()
        statistics.append(self.render(author: profile.asAuthor, manager: profile.asManager))
        
        self.detailsLabel.attributedText = details
        self.statisticsLabel.attributedText = statistics
    }
    
    func loadProfileImage() {
        guard let url = self.imageURL, url != "" else {
            return
        }
        
        self.profileImageView.loadImage(from: url)
    }
}

// MARK: - Renders
fileprivate extension ProfileView {

    func render(name: String?) -> NSMutableAttributedString {
        let attributedStrings = NSMutableAttributedString()
        
        // Name
        if let name = name {
            let text = name.firstLast.components(separatedBy: .whitespaces).joined(separator: .newLine)
            
            let style = Style {
                
                // Check if name is too long, and reduce the font size
                var pointSize: CGFloat = 40.0
                if name.count > 10 {
                    pointSize = 34
                    
                    if UIScreen.main.bounds.size.width < 375 {
                        pointSize = 27
                    }
                }

                // Configure font properties
                $0.font = SystemFonts.HelveticaNeue_Bold.font(size: pointSize)
                $0.color = UIColor(named: "MainTitle")
            }

            attributedStrings.append(text.set(style: style))
        }
        
        return attributedStrings
    }
    
    func render(link: String?) -> NSMutableAttributedString {
        let attributedStrings = NSMutableAttributedString()

        // Link
        if let link = link, let url = URL(string: link),
            let host = url.host {
            
            let style = Style {
                // Check if link is too long, and reduce the font size
                var pointSize: CGFloat = 14.0
                if link.count > 14, UIScreen.main.bounds.size.width < 375 {
                    pointSize = 12
                }

                $0.font = SystemFonts.HelveticaNeue_Medium.font(size: pointSize)
                $0.color = UIColor.Proposal.lightGray
            }

            let text = String.newLine + host + url.path
            attributedStrings.append(text.set(style: style))
        }

        return attributedStrings
    }
    
    func render(author: [Proposal]?, manager: [Proposal]?) -> NSMutableAttributedString {
        let attributedStrings = NSMutableAttributedString()

        // Styles
        let descriptionStyle = Style {
            $0.font = SystemFonts.HelveticaNeue.font(size: 20)
            $0.color = UIColor.Proposal.lightGray
        }
        
        let valueStyle = Style {
            $0.font = SystemFonts.HelveticaNeue_Bold.font(size: 18)
            $0.color = UIColor(named: "MainTitle")
            $0.alignment = .center
        }
        
        // as Author
        if let list = author, list.count > 0 {
            attributedStrings.append("\(list.count)".set(style: valueStyle))

            attributedStrings.append(" author".set(style: descriptionStyle))
        }
        
        // as Review Manager
        if let list = manager, list.count > 0 {
            let space = attributedStrings.length > 0 ? .doubleSpace + .doubleSpace : ""
            
            var text = space + "\(list.count)"
            attributedStrings.append(text.set(style: valueStyle))
            
            attributedStrings.append(" review manager".set(style: descriptionStyle))
        }
        
        return attributedStrings
    }
}
