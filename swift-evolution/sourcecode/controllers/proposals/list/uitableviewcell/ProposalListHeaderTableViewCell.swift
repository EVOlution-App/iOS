import Foundation
import UIKit

final class ProposalListHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var proposalsCountLabel: UILabel!
    
    // MARK: - Internal Attributes
    
    var proposalCount: Int = 0 {
        didSet {
            proposalsCountLabel.text = "\(proposalCount) proposals"
        }
    }
    
    var header: String? = "" {
        didSet {
            proposalsCountLabel.text = header
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(named: "SecBgColor")
    }
    
}
