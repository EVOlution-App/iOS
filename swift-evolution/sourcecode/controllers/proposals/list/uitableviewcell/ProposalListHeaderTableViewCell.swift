import Foundation
import UIKit

final class ProposalListHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var proposalsCountLabel: UILabel!
    
    // MARK: - Internal Attributes
    
    var proposalCount: Int = 0 {
        didSet {
            proposalsCountLabel.text = proposalCount > 0 ? "\(proposalCount) proposals" : ""
        }
    }
    
    var header: String? = "" {
        didSet {
            proposalsCountLabel.text = header
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupBackgroundColor()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBackgroundColor()
    }
    
    private func setupBackgroundColor() {
        contentView.backgroundColor = proposalCount > 0 ? UIColor(named: "SecBgColor") : UIColor(named: "BgColor")
    }
}
